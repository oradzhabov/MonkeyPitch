//
//  MyThread.swift
//  MonkeyPinch
//
//  Created by MacPC on 10/5/16.
//  Copyright © 2016 jazzros. All rights reserved.
//

import Foundation

class MyInputStream : NSObject {
    
    var buf1:String=Constants.ServerMsgTagConstants.DEVICELIST + String(Constants.ServerMsgTagConstants.TAG_DELIMETER) + "Device1,Device2,Device3"
    var buf2:String=Constants.ServerMsgTagConstants.ASKDEVICE_OK
    var buf3:String=Constants.ServerMsgTagConstants.ASKDEVICE_ERROR
    var curBuf:String=""
    func available() -> Int {
        
        switch MySocket.a {
        case 5:
            curBuf = buf1
        case 20:
            curBuf = buf2
        case 50:
            curBuf = buf3
        default:
            curBuf = ""
        }

        return curBuf.characters.count
    }
    func read( val: inout String) -> Void {
        val = curBuf
    }
}

class MySocket : NSObject {
    private let uuid: UUID
    
    init (_ uuid: UUID) {
        self.uuid = uuid
    }
    
    static var a:Int  = 0
    func isConnected() -> Bool {
        
        
        print ("MySocket isConnected \(MySocket.a)")
        Thread.sleep (forTimeInterval: 0.5)
        
        MySocket.a += 1
        if MySocket.a < 100 {
            return true
        }
        
        return false
    }

    
    func connect() throws -> Void {
        print ("MySocket::connect()...")
        Thread.sleep(forTimeInterval: 1)
        print ("MySocket::has been connected")
    }
    
    func close () throws -> Void {
        print ("MySocket::close()")
    }
    //
    let inStream:MyInputStream = MyInputStream()
    func getInputStream() -> MyInputStream{
        return inStream
    }
}

class ConnectThread : NSObject {
    private var viewController:MainViewController
    private var thread:Thread? = nil
    private var mmSocket:MySocket
    private var m_msgThread:ConnectedThread? = nil
    
    init (_ viewController: MainViewController) {
        self.viewController = viewController
        self.mmSocket = MySocket(UUID(uuidString: Constants.UUID.MY_UUID)! )
    }
    
    func start() -> Void {
        if thread == nil {
            self.viewController.waitingStart()
            thread = Thread(target:self, selector:#selector(ConnectThread.run(_:)), object:nil)
            thread?.start()
        }
    }
    
    func stop() -> Void {
        thread?.cancel()
        thread = nil
        
        cancel()
    }
    
    func run(_ param:Int) -> Void {
        
        // Cancel discovery because it will slow down the connection
/*
        if (mBluetoothAdapter.isDiscovering())
            mBluetoothAdapter.cancelDiscovery();
*/
        var isHasConnection = true;
        do {
            // Connect the device through the socket. This will block
            // until it succeeds or throws an exception
            try mmSocket.connect()
        } catch {
            isHasConnection = false;
            // Unable to connect; close the socket and get out
            do {
                try mmSocket.close()
            } catch {
                ///
            }
        }
        
        self.viewController.waitingStop();
   
        if isHasConnection {
            
            if (m_msgThread == nil) {
                m_msgThread = ConnectedThread(mmSocket, by: self);
                m_msgThread?.start();
                //
                //m_msgThread.sendText("Device connected");
            }
            
            // Do work to manage the connection (in a separate thread)
            manageConnectedSocket();
        } else {
        }
    }
    /** Will cancel an in-progress connection, and close the socket */
    func cancel() -> Void {
        do {
            // to interrupt reading thread we should close socket before
    
            if (m_msgThread != nil) {
                m_msgThread?.cancel();
                m_msgThread = nil;
            }
            try mmSocket.close();
        } catch {
            // e.printStackTrace();
        }
    }
    func sendText(_ text: String ) -> Void{
        if m_msgThread != nil {
            m_msgThread?.sendText(text);
        }
    }
    
    func sendCode(_ code: Int) -> Void {
        if m_msgThread != nil {
            m_msgThread?.sendCode(code);
        }
    }
    
    // Do work to manage the connection (in a separate thread)
    private func manageConnectedSocket() -> Void {
        DispatchQueue.global().async {
            // Disable acitivity till server returneed answer
            self.viewController.waitingStart();
            
            /**
             * Initiate process of connection by request the device list
             */
            self.sendText(Constants.ServerMsgTagConstants.DEVICELIST);
        }
    }
    /*
     ========================================================================================
     */
    private class ConnectedThread : NSObject {
        private var thread:Thread? = nil
        private var mmSocket:MySocket
        private var mmInStream:MyInputStream;
        private var parent:ConnectThread
        
        init (_ socket: MySocket, by parent: ConnectThread) {
            self.parent = parent
            self.mmSocket = socket
            self.mmInStream = socket.getInputStream();
        }
        
        func start() -> Void {
            if thread == nil {
                thread = Thread(target:self, selector:#selector(ConnectedThread.run(_:)), object:nil)
                thread?.start()
            }
        }
        func cancel() -> Void {
            thread?.cancel()
            thread = nil
        }
        
        func run(_ param:Int) -> Void {

            while thread?.isExecuting == true {
                if mmSocket.isConnected() {
                    if mmInStream.available() > 0 {
                        var bufStr: String = "";
                        mmInStream.read(val: &bufStr)
                        
                        let tag_delim = Constants.ServerMsgTagConstants.TAG_DELIMETER
                        
                        let bufStrTokens = bufStr.characters.split{ $0 == tag_delim}.map(String.init)
                        
                        
                        
                        
                        if bufStrTokens.count > 0 {
                            switch bufStrTokens[0] {
                            case Constants.ServerMsgTagConstants.DEVICELIST:
                                var sendMsgText:String = ""
                                if bufStrTokens.count > 1 {
                                    sendMsgText = bufStrTokens[1]
                                }
//                                print ("DEVICELIST " + sendMsgText)
                                self.parent.viewController.serverNotofication(
                                    what: ServerMsgHandler.NOTIFY_SERVER_DEVICELIST,
                                    msg: sendMsgText)
                                break
                            case Constants.ServerMsgTagConstants.ASKDEVICE_OK:
//                                print ("ASKDEVICE_OK")
                                self.parent.viewController.serverNotofication(
                                    what: ServerMsgHandler.NOTIFY_SERVER_ASKEDDEVICE_OK,
                                    msg: "")
                                break
                            case Constants.ServerMsgTagConstants.ASKDEVICE_ERROR:
//                                print ("ASKDEVICE_ERROR")
                                self.parent.viewController.serverNotofication(
                                    what: ServerMsgHandler.NOTIFY_SERVER_ASKEDDEVICE_ERROR,
                                    msg: "")
                                break
                            default:
                                break
                            }
                        }
                        
                    }
                    /** todo:
                     * actually here we roll in loop and could obtain msg from server.
                     * we could stop rolling by finishing this loop, but in such a case we could not obtain msgs from server
                     */
                    Thread.sleep(forTimeInterval: 0.01)
                } else {
                    break
                }
                
            }
            // Similar to \connectionLost() but without UI-alert notification
            parent.cancel();
        }
        
        func sendText(_ someText: String ) -> Void {
            do {
                if mmSocket.isConnected() {
                    let txtLength = "\(someText.characters.count)"
                    let txtOutput = txtLength + String(Constants.ServerMsgTagConstants.TAG_DELIMETER) + someText;
                    
//                    mmOutStream.write(txtOutput.getBytes(Charset.forName("UTF-8")));
print ("sendText: " + txtOutput)
                }
            } catch {
                connectionLost();
            }
        }
        
        func sendCode(_ code: Int) -> Void {
            do {
                if mmSocket.isConnected() {
//                    mmOutStream.write(code);
                }
            } catch {
                connectionLost();
            }
        }
        private func connectionLost() -> Void {
            parent.cancel();
            // todo: UI alert and back-pressed
        }
    }
}

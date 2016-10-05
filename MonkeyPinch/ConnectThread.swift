//
//  MyThread.swift
//  MonkeyPinch
//
//  Created by MacPC on 10/5/16.
//  Copyright © 2016 jazzros. All rights reserved.
//

import Foundation


class MySocket : NSObject {
    private let uuid: UUID
    
    init (_ uuid: UUID) {
        self.uuid = uuid
    }
    func connect() throws -> Void {
        Thread.sleep(forTimeInterval: 3)
    }
    
    func close () throws -> Void {
        
    }
}

class ConnectThread : NSObject {
    private var viewController:ViewController
    private var thread:Thread? = nil
    private var mmSocket:MySocket
    private var m_msgThread:ConnectedThread? = nil
    
    init (_ viewController: ViewController) {
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
//            manageConnectedSocket();
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
    /*
     ========================================================================================
     */
    private class ConnectedThread : NSObject {
        private var thread:Thread? = nil
        private var mmSocket:MySocket
        private var parent:ConnectThread
        
        init (_ socket: MySocket, by parent: ConnectThread) {
            self.parent = parent
            self.mmSocket = socket
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
            var i:Int = 0
            while thread?.isExecuting == true {
                print ("MyThread run \(i)")
                Thread.sleep (forTimeInterval: 0.5)
                i += 1
                
                if i >= 10 {
                    break
                }
            }
            cancel()
        }
        
        func sendText(_ text: String ) -> Void{
            do {
                
            } catch {
                connectionLost();
            }
        }
        
        func sendCode(_ code: Int) -> Void {
            do {
                
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

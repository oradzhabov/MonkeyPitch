//
//  ServerMsgHandler.swift
//  MonkeyPinch
//
//  Created by MacPC on 10/10/16.
//  Copyright © 2016 jazzros. All rights reserved.
//

import Foundation
import UIKit

class ServerMsgHandler : NSObject  {
    
    internal var owner: MainViewController
    internal var selected_joystick_name:String = "";
    internal var deviceNameList = [String]()
    internal var onRowSelect: ((_ device : String)->Void)? = nil
    public static let  NOTIFY_SERVER_DEVICELIST:Int = 1;
    public static let  NOTIFY_SERVER_ASKEDDEVICE_OK:Int = 2;
    public static let  NOTIFY_SERVER_ASKEDDEVICE_ERROR:Int = 3;
    
    init (_ owner: MainViewController , onRowSelect: @escaping (_ device: String)->Void) {
        self.owner = owner
        self.onRowSelect = onRowSelect
    }
    public func handleMessage(what : Int, msg: String) -> Void {
        
        // In any case what ever received from server, enable activity
        owner.waitingStop();
        
        DispatchQueue.main.async {
            switch (what) {
                
            case ServerMsgHandler.NOTIFY_SERVER_DEVICELIST:
                var strDeviceList = msg;
                print ("NOTIFY_SERVER_DEVICELIST with: " + strDeviceList)
                
                if (strDeviceList.characters.count > 0) {
                    
                    let devices = strDeviceList.characters.split
                        { $0 == Constants.ServerMsgTagConstants.DEVICELIST_DELIMETER}.map(String.init)
                    
                    self.deviceNameList = devices
                    if (devices.count > 0) {
                        //
                        // Update list of devices
                        //
                        self.owner.refreshView()
                        /*
                        AlertDialog.Builder builderSingle = new AlertDialog.Builder(MainActivity.this);
                        builderSingle.setTitle(getResources().getString(R.string.dlgSelectJoystickDeviceTitle));
                        
                        final ArrayAdapter<String> arrayAdapter = new ArrayAdapter<String>(
                            MainActivity.this,
                            android.R.layout.select_dialog_item);
                        
                        
                        for (String deviceName : devices) {
                            arrayAdapter.add(deviceName);
                        }
                        
                        builderSingle.setNegativeButton(
                            R.string.cancel,
                            new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    
                                    turnOffConnection();
                                    dialog.dismiss();
                                }
                        });
                        
                        builderSingle.setAdapter(
                            arrayAdapter,
                            new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    
                                    selected_joystick_name = arrayAdapter.getItem(which);
                                    AlertDialog.Builder builderInner = new AlertDialog.Builder(
                                        MainActivity.this);
                                    
                                    // Disable acitivity till server returneed answer
                                    waitingStart();
                                    
                                    sendText(ServerMsgTagConstants.ASKDEVICE + ServerMsgTagConstants.TAG_DELIMETER + selected_joystick_name);
                                }
                        });
                        builderSingle.show();
                        */
                    }
                } else {
                    /*
                    turnOffConnection();
                    
                    new AlertDialog.Builder(MainActivity.this)
                        .setTitle(getResources().getString(R.string.dlgSelectJoystickDeviceInfromNoJoysticksTittle))
                        .setMessage(getResources().getString(R.string.dlgSelectJoystickDeviceInfromNoJoysticksMessages))
                        .setPositiveButton(getResources().getText(R.string.ok), new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface arg0, int arg1) {
                                // Some stuff to do when ok got clicked
                            }
                        })
                        .show();
                    */
                }
                break
            case ServerMsgHandler.NOTIFY_SERVER_ASKEDDEVICE_OK:
                /*
                
                Intent intent = new Intent(MainActivity.this, JoystickActivity.class);
                
                Bundle bundle = new Bundle();
                bundle.putString("selected_joystick_name", selected_joystick_name);
                intent.putExtras(bundle);
                
                startActivityForResult(intent, REQUEST_CANCELCONNECTION_BT);
                 */

                if self.selected_joystick_name.characters.count > 0 {
                    print ("NOTIFY_SERVER_ASKEDDEVICE_OK for: " + self.selected_joystick_name)
                    
                    let controller = self.owner.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.owner.present(controller, animated: true, completion: nil)
                }
                break;
            case ServerMsgHandler.NOTIFY_SERVER_ASKEDDEVICE_ERROR:
                /*
                turnOffConnection();
                
                new AlertDialog.Builder(MainActivity.this)
                    .setTitle(getResources().getString(R.string.dlgSelectJoystickDeviceInfromErrorTittle))
                    .setMessage(getResources().getString(R.string.dlgSelectJoystickDeviceInfromErrorMessage))
                    .setPositiveButton(getResources().getText(R.string.ok), new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface arg0, int arg1) {
                            // Some stuff to do when ok got clicked
                        }
                    })
                    .show();
                */
                break;
            default:
                break
            }
        }
    }
    
}

extension ServerMsgHandler :
        UITableViewDataSource,
        UITableViewDelegate{
    //
    // UITableViewDataSource Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return deviceNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->   UITableViewCell
    {
        let cell = UITableViewCell()
        let label = UILabel()
        label.frame = CGRect(x:0, y:0, width:200, height:50)
        label.text = deviceNameList[indexPath.item]
        cell.addSubview(label)
        return cell
    }
    
    //
    // UITableViewDelegate Functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_joystick_name = deviceNameList[indexPath.item]
        onRowSelect! (selected_joystick_name)
    }
}

//
//  ServerMsgHandler.swift
//  MonkeyPinch
//
//  Created by MacPC on 10/10/16.
//  Copyright © 2016 jazzros. All rights reserved.
//

import Foundation

class ServerMsgHandler : NSObject {
    private var owner: ViewController
    private var selected_joystick_name:String = "";
    public static let  NOTIFY_SERVER_DEVICELIST:Int = 1;
    public static let  NOTIFY_SERVER_ASKEDDEVICE_OK:Int = 2;
    public static let  NOTIFY_SERVER_ASKEDDEVICE_ERROR:Int = 3;
    
    init (_ owner: ViewController ) {
        self.owner = owner
    }
    public func handleMessage(what : Int, msg: String) -> Void {
        // In any case what ever received from server, enable activity
        owner.waitingStop();
        
        switch (what) {
            
        case ServerMsgHandler.NOTIFY_SERVER_DEVICELIST:
            var strDeviceList = msg;
            if (strDeviceList.characters.count > 0) {
                
                let devices = strDeviceList.characters.split
                    { $0 == Constants.ServerMsgTagConstants.DEVICELIST_DELIMETER}.map(String.init)
                
                if (devices.count > 0) {
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

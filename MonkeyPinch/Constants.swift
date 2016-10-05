//
//  Constants.swift
//  MonkeyPinch
//
//  Created by MacPC on 9/29/16.
//  Copyright © 2016 jazzros. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct FileName {
        // static let Button = "banana.png"
    }
    struct Size {
        static let JoystickButton = CGSize(width: 30, height: 30)
    }
    struct Color {
        static let LightGrey = UIColor.lightGray
        static let Blue = UIColor.blue
        static let JoyButton = UIColor(red: 1.0, green: 0.0, blue: 0.5, alpha: 1.0)
        
    }
    
    // Common for all parts of application UUID
    struct UUID {
        static let MY_UUID = "B62C4E8D-62CC-404b-BBBF-BF3E3BBB1374"
    }
    
    // This structure should be conicident with other parts of application
    // Structure's name is similar to Android's analogue
    struct ServerMsgTagConstants {
        static let  DEVICELIST = "DEVICELIST"
        static let  ASKDEVICE = "ASKDEVICE"
        static let  ASKDEVICE_OK = "ASKDEVICE_OK"
        static let  ASKDEVICE_ERROR = "ASKDEVICE_ERROR"
        static let  TAG_DELIMETER = " "
        static let  DEVICELIST_DELIMETER = ","
    }
}

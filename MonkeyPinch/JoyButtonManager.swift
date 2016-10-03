//
//  JoyButtonManager.swift
//  MonkeyPinch
//
//  Created by MacPC on 10/3/16.
//  Copyright © 2016 jazzros. All rights reserved.
//

import Foundation
import UIKit

class JoyButtonManager : NSObject, UIGestureRecognizerDelegate {
    
    private var controller : UIViewController? = nil
    private var imgArray = [JoyButton]()
    
    /*
        Return values:
        true - success
        false - error
     */
    func addButton(to controller: UIViewController?,
                   for pnt: CGPoint, mode lMode: MyButtonMode,
                  delegate playDelegate: ((_ state: UIGestureRecognizerState, _ me: JoyButton) -> Void)?) -> Bool {
        
        let newIndex = getFirstFreeBtnIndex()
        if newIndex >= 0 {
            self.controller = controller
            
            let img = JoyButton()
            
            img.build(to: (self.controller?.view)!,
                      for: pnt,
                      mode: lMode,
                      id: newIndex,
                      delegate: playDelegate,
                      longTapdelegate: deleteBtnDelegate)
            
            imgArray.append(img)
            
            return true
        }
        return false
    }
    
    /*
        Add the new button by LongClick in EditMode
    */
    func longTapHandler(recognizer: UILongPressGestureRecognizer) {
        
        if recognizer.state == .began {
            
            var touchLocation: CGPoint = recognizer.location(in: recognizer.view)
            //touchLocation = recognizer.convertPointFromView(touchLocation)
            
            touchLocation.x -= Constants.Size.JoystickButton.width / 2
            touchLocation.y -= Constants.Size.JoystickButton.height / 2
            
            _ = addButton(to: controller,
                      for: touchLocation,
                     mode: MyButtonMode.Edit)
            { (_ state: UIGestureRecognizerState, _ me: JoyButton) -> Void in
                print ("Press Image \(me.getJoyIndex()) with state \(state)")
            }
        }
    }
    
    func doubleTapHandler(recognizer: UITapGestureRecognizer) {
        setPlayMode()
    }
    
    func setPlayMode() -> Void {
        (self.controller?.view)!.backgroundColor = Constants.Color.Blue
        for img in imgArray {
            img.setMode(mode: MyButtonMode.Play)
        }
        clearRecognizerArray()
    }
    func setEditMode() -> Void {
        (self.controller?.view)!.backgroundColor = Constants.Color.LightGrey
        for img in imgArray {
            img.setMode(mode: MyButtonMode.Edit)
        }
        clearRecognizerArray()
        //
        //
        //
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(JoyButtonManager.longTapHandler(recognizer:)))
        
        gesture.allowableMovement = 10
        (self.controller?.view)!.addGestureRecognizer(gesture)
        //
        //
        //
        // Double Tap
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JoyButtonManager.doubleTapHandler(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        (self.controller?.view)!.addGestureRecognizer(doubleTapGesture)
    }
    
    func save () -> Bool {
        let filePath = self.dataFilePath()
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(imgArray, forKey: "imgArray")
        archiver.finishEncoding()
        let success = data.write(toFile: filePath, atomically: true)
        // If anything went wrong while writing the file, success will be set to NO
        return success
    }
    func load (to controller: UIViewController?,
               delegate playDelegate: ((_ state: UIGestureRecognizerState, _ me: JoyButton) -> Void)?)
        -> Void {
        
        let filePath = self.dataFilePath()
        if (FileManager.default.fileExists(atPath: filePath)) {
            self.controller = controller
            
            let data = NSData(contentsOfFile: filePath)
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data as! Data)
            let object = unarchiver.decodeObject(forKey: "imgArray")
            unarchiver.finishDecoding()
            
            clear()
            
            imgArray = object as! [JoyButton]
            //
            // Finish building objects
            //
            for obj in imgArray {
                obj.build(to: (self.controller?.view)!,
                          delegate: playDelegate,
                          longTapdelegate : deleteBtnDelegate)
            }
            setPlayMode()
        }
    }
    
    private func getFirstFreeBtnIndex() -> Int {
        for i in 1 ..< 33 {
            var exist : Bool = false
            for item in imgArray {
                if item.getJoyIndex() == i {
                    exist = true
                    break
                }
            }
            if exist == false {
                return i
            }
        }
        // Has no free indices
        return 0
    }
    private func clearRecognizerArray()->Void {
        if ((self.controller?.view)!.gestureRecognizers != nil) {
            for gesture in (self.controller?.view)!.gestureRecognizers! {
                (self.controller?.view)!.removeGestureRecognizer(gesture)
            }
        }
    }
    private func clear() -> Void {
        for obj in imgArray {
            obj.clear()
        }
        imgArray.removeAll()
    }
    private func deleteBtnDelegate (_ me: JoyButton) {
        // create the alert
        let alert = UIAlertController(title: "Confirmation",
                                      message: "Are you sure want to delete button?",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertActionStyle.default,
                                      handler: { action in
                                        let index = self.imgArray.index{$0 === me}
                                        me.clear()
                                        self.imgArray.remove(at: index!)
                                        
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertActionStyle.cancel,
                                      handler: nil))
        
        // show the alert
        controller?.present(alert, animated: true, completion: nil)
    }
    private func dataFilePath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let documentsDirectory = paths[0] as NSString

        return documentsDirectory.appendingPathComponent ("data.archive") as String
    }
}

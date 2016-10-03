//
//  JoyButton.swift
//  MonkeyPinch
//
//  Created by MacPC on 9/28/16.
//  Copyright © 2016 jazzros. All rights reserved.
//

import UIKit

enum MyButtonMode : Int {
    
    case Edit
    case Play
}

class JoyButton : NSObject, UIGestureRecognizerDelegate
{
    var joyId: Int = 0
    var parentView: UIView? = nil
    var imageView:UIImageView? = nil
    var playDelegate: ((_ state: UIGestureRecognizerState, _ me: JoyButton) -> Void)? = nil
    var longTapDelegate: ((_ me: JoyButton) -> Void)? = nil
    
    
    
    func build(to view: UIView,
               for orig: CGPoint,
               mode lMode: MyButtonMode,
               id lId: Int,
               delegate playDelegate: ((_ state: UIGestureRecognizerState, _ me: JoyButton) -> Void)?,
               longTapdelegate longTapDelegate: ((_ me: JoyButton) -> Void)?) -> Void
    {
        self.joyId = lId;
        let image = UIImage(named: Constants.FileName.Button)
        
        imageView = UIImageView(image: image!)
        imageView?.isUserInteractionEnabled = true

        
        imageView?.frame = CGRect(origin: orig, size: Constants.Size.JoystickButton)
        imageView?.contentMode = UIViewContentMode.scaleToFill
        
        self.parentView = view
        self.parentView?.addSubview(imageView!)
        
//        imageView.layer.cornerRadius = 0.5 * imageView.bounds.size.width
//        imageView?.isUserInteractionEnabled = true
        
       
        
        // img.clipsToBounds = true
        
        
        self.playDelegate = playDelegate
        self.longTapDelegate = longTapDelegate
        
        setMode(mode: lMode)

    }
    func setPlayMode() -> Void {
        
        clearRecognizerArray()
        
        let recognizer = CustomGestureRecognizer (target: self, action: #selector(JoyButton.handleTap(recognizer:)))
        
        recognizer.delegate = self
        imageView?.addGestureRecognizer(recognizer)
    }
    
    func setEditMode() -> Void {
        
        clearRecognizerArray()
        
        let recognizer = UIPanGestureRecognizer (target: self, action: #selector(JoyButton.handlePan(recognizer:)))
        recognizer.delegate = self
        imageView?.addGestureRecognizer(recognizer)
        //
        //
        //
        let recognizer2 = UILongPressGestureRecognizer(target: self, action: #selector(JoyButton.handleLongTap(recognizer:)))
        recognizer2.delegate = self
        imageView?.addGestureRecognizer(recognizer2)
    }
    func getJoyIndex() -> Int {
        return self.joyId
    }
    func clear ()
    {
        clearRecognizerArray()
        imageView?.removeFromSuperview()
    }
    
    func setMode (mode lMode: MyButtonMode)
    {
        switch lMode
        {
        case MyButtonMode.Play:
            setPlayMode()
        case MyButtonMode.Edit:
            setEditMode()
        }
    }
    
    private func clearRecognizerArray()->Void {
        if imageView?.gestureRecognizers != nil {
            for gesture in (imageView?.gestureRecognizers)! {
                imageView?.removeGestureRecognizer(gesture)
            }
        }
    }
    

    
    func handleTap(recognizer: CustomGestureRecognizer) {
        if self.playDelegate != nil {
            self.playDelegate!(recognizer.state, self)
        }
    }
    
    func handlePan(recognizer:UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.parentView)
        
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.parentView)
 
    }
    func handleLongTap(recognizer: UILongPressGestureRecognizer) {
        if self.longTapDelegate != nil {
            self.longTapDelegate!(self)
        }
    }
}

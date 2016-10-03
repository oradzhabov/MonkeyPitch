//
//  CircleGestureRecognizer.swift
//  MonkeyPinch
//
//  Created by MacPC on 9/28/16.
//  Copyright © 2016 jazzros. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass


// gestures
// http://flexmonkey.blogspot.com/2015/03/creating-custom-gesture-recognisers-in.html
// https://www.raywenderlich.com/104744/uigesturerecognizer-tutorial-creating-custom-recognizers
// http://www.raywenderlich.com/76020/using-uigesturerecognizer-with-swift-tutorial

// bluetooth
// http://anasimtiaz.com/?p=201

// Good Swift programming tips
// http://savvyapps.com/blog/swift-tips-for-developers

// Swipe menu example
// https://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/

class CustomGestureRecognizer: UIGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event!)
        state = .began
        
        //print ("CustomGestureRecognizer touchesBegan")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event!)
        state = .changed
        
        //print ("CustomGestureRecognizer touchesMoved")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event!)
        state = .ended
        
        //print ("CustomGestureRecognizer touchesEnded")
    }
}

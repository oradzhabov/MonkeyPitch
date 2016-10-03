//
//  MyButton.swift
//  MonkeyPinch
//
//  Created by MacPC on 9/28/16.
//  Copyright © 2016 jazzros. All rights reserved.
//

// import Foundation
import UIKit



class MyButton : NSObject
{
    var mode : MyButtonMode = MyButtonMode.Play
    
    func build(to view: UIView, for orig: CGPoint, mode lMode: MyButtonMode) -> Void
    {

        let button = UIButton(type: .custom)
        
        button.frame = CGRect(origin: orig, size: CGSize(width: 50, height: 50))
        //button.layer.cornerRadius = 0.5 * button.bounds.size.width
        
        button.setImage(UIImage(named:"banana.png"), for: .normal)
            
        button.addTarget(self, action: #selector(MyButton.touchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(MyButton.touchDragExit(sender:)), for: .touchDragExit)
        button.addTarget(self, action: #selector(MyButton.touchUpInside(sender:)), for: .touchUpInside)
            
        button.clipsToBounds = true
        
        self.mode = lMode
            
        
        view.addSubview(button)
    }
    func touchDown(sender: AnyObject) {
        print("button touchDown")
    }
    func touchDragExit(sender: AnyObject) {
        print("button touchDragExit")
    }
    func touchUpInside(sender: AnyObject) {
        print("button touchUpInside")
    }
}

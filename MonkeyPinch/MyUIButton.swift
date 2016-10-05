//
//  MyUIButton.swift
//  MonkeyPinch
//
//  Created by MacPC on 10/5/16.
//  Copyright © 2016 jazzros. All rights reserved.
//

import UIKit

class MyUIButton: UIView {

    required override init(frame: CGRect) {
        super.init(frame: frame)
        myInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        myInit()
    }
    
    // let frame = CGRect(x: 0, y: 0, width: 100, height: 50)
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.clear(rect)

        let white = UIColor.white.cgColor
        let red = Constants.Color.JoyButton.cgColor
        context.setFillColor(red)
        context.setLineWidth(0)
        context.addEllipse(in: rect)
        context.drawPath(using: .fillStroke)
        
        let lineWidth = Constants.Size.JoystickButton.width * 0.1
        let lineLength = Constants.Size.JoystickButton.width * 0.5
        context.setFillColor(white)
        // Draw vertical line
        context.addRect(CGRect(origin: CGPoint(x: (Constants.Size.JoystickButton.width - lineWidth)/2,
                                               y: (Constants.Size.JoystickButton.height - lineLength)/2),
                               size: CGSize(width: lineWidth,
                                height: lineLength)))
        context.drawPath(using: .fillStroke)
        // Draw horizontal line
        context.addRect(CGRect(origin: CGPoint(x: (Constants.Size.JoystickButton.width - lineLength)/2,
                                               y: (Constants.Size.JoystickButton.height - lineWidth)/2),
                               size: CGSize(width: lineLength,
                                            height: lineWidth)))
        context.drawPath(using: .fillStroke)
        
    }


    private func myInit()->Void {
        self.backgroundColor = UIColor.blue.withAlphaComponent(0)
        self.isOpaque = false
    }
}

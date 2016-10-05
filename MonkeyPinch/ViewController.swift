//
//  ViewController.swift
//  MonkeyPinch
//
//  Created by MacPC on 9/27/16.
//  Copyright © 2016 jazzros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    private var loadingView: UIView = UIView()

    var btnManager = JoyButtonManager()
    
    
    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    private func addImage(for pnt: CGPoint, mode lMode: MyButtonMode,
                  delegate playDelegate: ((_ state: UIGestureRecognizerState, _ me: JoyButton) -> Void)?) -> Void {
        _ = btnManager.addButton(to: self, for: pnt, mode: lMode, delegate: playDelegate)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // According to disable autorotate and enable only strickt position mode,
        // working ahead with \shouldAutorotate
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")


        addImage(for: CGPoint(x:0,y:50),
                 mode: MyButtonMode.Edit)
        { (_ state: UIGestureRecognizerState, _ me: JoyButton) -> Void in
            print ("Press Image \(me.getJoyIndex()) with state \(state)")
        }
var thread = ConnectThread(self)
        addImage(for: CGPoint(x:50,y:50),
                 mode: MyButtonMode.Play)
        { (_ state: UIGestureRecognizerState, _ me: JoyButton) -> Void in
            switch state {
            case .began:
                thread.start()
                print ("Press Image \(me.getJoyIndex())")
                break
            case .ended:
                thread.stop()
                print ("Release Image \(me.getJoyIndex())")
                self.btnManager.setEditMode()
                break
            default: break
            }
            
        }
        
        self.btnManager.setPlayMode()
        
        
//        btnManager.load(to: self, delegate: playDelegate)
        
        //
        // Assign notification for save preferences
        //
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self,
                        selector: #selector(ViewController.applicationWillResignActive(notification:)),
                        name: NSNotification.Name.UIApplicationWillResignActive,
        object: app)
    }
    func applicationWillResignActive(notification:NSNotification) {
        _ = btnManager.save()
    }
    
    func waitingStart() {
        DispatchQueue.main.async {
            self.loadingView = UIView()
            self.loadingView.frame = self.view.frame
            self.loadingView.center = self.view.center
            self.loadingView.backgroundColor = UIColor.gray
            self.loadingView.alpha = 0.7
//            self.loadingView.clipsToBounds = true
//            self.loadingView.layer.cornerRadius = 10
            
            self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)
        
        
            self.loadingView.addSubview(self.spinner)
            self.view.addSubview(self.loadingView)
            self.spinner.startAnimating()
        }
    }
    func waitingStop() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }
    
    func playDelegate(_ state: UIGestureRecognizerState, _ me: JoyButton) -> Void {
        switch state {
        case .began:
            print ("Press Image \(me.getJoyIndex())")
            break
        case .ended:
            print ("Release Image \(me.getJoyIndex())")
            // self.imgArray[0].setMode(mode: MyButtonMode.Play)
            //self.btnManager.setEditMode()
            break
        default: break
        }
    }

}


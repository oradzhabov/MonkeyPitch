//
//  MainViewController.swift
//  MonkeyPinch
//
//  Created by MacPC on 10/10/16.
//  Copyright © 2016 jazzros. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    private var loadingView: UIView = UIView()
    private var thread:ConnectThread? = nil
    
    @IBOutlet var deviceListTable: UITableView!
    
    private var serverMsgHandler:ServerMsgHandler? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // instance it before thread
        serverMsgHandler = ServerMsgHandler(self) {selected_joystick_name in
            //
            // Send to server request to access device.
            // If server will answer OK, ServerMsgManager will redirect view to Joystick
            //
            print ("SELECT " + selected_joystick_name)

            // Disable view till server returneed answer
            self.waitingStart();
            
            self.thread?.sendText(Constants.ServerMsgTagConstants.ASKDEVICE +
                            String(Constants.ServerMsgTagConstants.TAG_DELIMETER) +
                            selected_joystick_name);
        }
        
        //
        //
        //
        deviceListTable.dataSource = serverMsgHandler as UITableViewDataSource?
        deviceListTable.delegate = serverMsgHandler as UITableViewDelegate?
        
        thread = ConnectThread(self)
        thread?.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func serverNotofication(what : Int, msg: String) -> Void {
        self.serverMsgHandler?.handleMessage(what: what, msg: msg)
    }
    func refreshView() -> Void {
        deviceListTable.reloadData()
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
            print ("waitingStart")
        }
    }
    func waitingStop()
    {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
            print ("waitingStop")
        }
    }
}

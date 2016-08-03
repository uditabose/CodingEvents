//
//  BounceBaseViewController.swift
//  Bounce
//
//  Created by Bounce Team on 12/14/14.
//  Copyright (c) 2014 NYUPoly. All rights reserved.
//

import UIKit

class BounceBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTitleText(title:String) {
        // TODO : change the title to image
        self.title = title
    }
    
    func hideNavBar() {
        self.navigationController?.navigationBar.hidden = true
    }
    
    func showNavBar() {
        self.navigationController?.navigationBar.hidden = false
    }
    
    func hideBackButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func setLogoutButton() {
        self.showNavBar()
        let logoutButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "logoutAction:")
        let actionButtonItems:NSArray = [logoutButton]
        self.navigationItem.rightBarButtonItems = actionButtonItems;
    }
    
    func logoutAction(sender: UIBarButtonItem!) {
        println(" Logout pressed ")
        if (FBSession.activeSession().state == FBSessionState.Open ||
            FBSession.activeSession().state == FBSessionState.OpenTokenExtended) {
                FBSession.activeSession().closeAndClearTokenInformation()
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

}

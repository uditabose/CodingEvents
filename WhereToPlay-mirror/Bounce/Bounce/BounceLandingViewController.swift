//
//  BounceLandingViewController.swift
//  Bounce
//
//  Created by Bounce Team on 11/27/14.
//  Copyright (c) 2014 NYUPoly. All rights reserved.
//

import UIKit

class BounceLandingViewController: BounceBaseViewController, BounceFacebookLoginHandler {

    @IBOutlet weak var facebookConnectButton: UIButton!
    
    var userEmail: String?
    let facebookUtil: BounceFacebookUtil = BounceFacebookUtil()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookUtil.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor =
            UIColor(patternImage: UIImage(named: "background-BounceLanding")!) // add ! mark if it does not compile
        
        if (FBSession.activeSession().state == .CreatedTokenLoaded) {
            FBSession.openActiveSessionWithReadPermissions(["public_profile", "email"], allowLoginUI: true, completionHandler: {
                (session:FBSession!, state:FBSessionState, error:NSError!) -> Void in
                self.facebookUtil.sessionStateChanged(session, state: state, error: error)
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.hideNavBar()
        self.setTitleText("Bounce")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.userEmail = nil
    }

    @IBAction func facebookButtonTouced(sender: AnyObject) {
        if (FBSession.activeSession().state == FBSessionState.Open ||
            FBSession.activeSession().state == FBSessionState.OpenTokenExtended) {
                FBSession.activeSession().closeAndClearTokenInformation()
        } else {
            FBSession.openActiveSessionWithReadPermissions(["public_profile", "email"], allowLoginUI: true, completionHandler: {
                (session:FBSession!, state:FBSessionState, error:NSError!) -> Void in
                self.facebookUtil.sessionStateChanged(session, state: state, error: error)
            })
        }
    }
    
    func onSuccess() {
        
        self.performSegueWithIdentifier("fbToHomeSegue", sender: self)
        
    }
    
    func onFailure() {
        let loginErrorAlert:UIAlertController = UIAlertController(title: "Login Error", message: "Invalid Facebook Credentials", preferredStyle: UIAlertControllerStyle.Alert)
         loginErrorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
            loginErrorAlert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(loginErrorAlert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if userEmail == nil {
            userEmail = ""
        }
        println("prepareForSegue - \(self.userEmail)")
        if (segue.identifier == "fbToHomeSegue") {
            FBRequest.requestForMe().startWithCompletionHandler { (connection:FBRequestConnection!, user:AnyObject!, error:NSError!) -> Void in
                let userDict = user as NSDictionary
                println(userDict)
                self.userEmail = userDict.valueForKey("email") as? String
            }
            let homeViewController = segue.destinationViewController as BounceHomeViewController
            homeViewController.userEmail = self.userEmail
        }
    }
}


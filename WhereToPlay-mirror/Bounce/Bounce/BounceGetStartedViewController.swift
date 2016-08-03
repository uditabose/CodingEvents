//
//  BounceGetStartedViewController.swift
//  Bounce
//
//  Created by Bounce Team on 11/27/14.
//  Copyright (c) 2014 NYUPoly. All rights reserved.
//

import UIKit

class BounceGetStartedViewController: BounceBaseViewController {
    
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.hidden = false
        self.passwordField.secureTextEntry = true

        // Background image
        
        self.view.backgroundColor =
            UIColor(patternImage: UIImage(named: "background-Login")!) // add ! mark if it does not compile
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.hideNavBar()
        self.setTitleText("Sign-In")
    }
    
    @IBAction func confirmButtonPressed(sender: AnyObject) {
        if (BounceJSONDataStore.validateUserData(self.userNameField.text, password: self.passwordField.text)) {
            self.performSegueWithIdentifier("loginToHomeSegue", sender: self)
        } else {
            let alert = UIAlertController(title: "Signup error", message: "Invalid input", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
        self.userNameField.text = ""
        self.passwordField.text = ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginToHomeSegue" {
            let homeViewController: BounceHomeViewController = segue.destinationViewController as BounceHomeViewController
            homeViewController.userEmail = self.userNameField.text
        }
    }
}

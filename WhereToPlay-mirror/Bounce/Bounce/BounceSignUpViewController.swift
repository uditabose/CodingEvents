//
//  BounceLoginOptionViewController.swift
//  Bounce
//
//  Created by Bounce Team on 11/27/14.
//  Copyright (c) 2014 NYUPoly. All rights reserved.
//

import UIKit

class BounceSignUpViewController: BounceBaseViewController {
    
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var retypePasswordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordField.secureTextEntry = true
        self.retypePasswordField.secureTextEntry = true
        
        // Background image
        self.view.backgroundColor =
            UIColor(patternImage: UIImage(named: "background-Signup")!) // add ! mark if it does not compile
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.hideNavBar()
        self.setTitleText("Sign-Up")
    }
    
    
    @IBAction func signupConfirmPressed(sender: AnyObject) {
        var isOk = BounceJSONDataStore.validateUserData(userNameField.text, password: passwordField.text)
        
        if (isOk && passwordField.text == retypePasswordField.text) {
            isOk = true
        }
        
        if isOk {
            self.performSegueWithIdentifier("signUpToHomeSegue", sender: self)
        } else {
            let alert = UIAlertController(title: "Signup error", message: "Invalid input", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signUpToHomeSegue" {
            let homeViewController:BounceHomeViewController = segue.destinationViewController as BounceHomeViewController
            homeViewController.userEmail = userNameField.text
        }
    }
    
    
}


//
//  BounceHomeViewController.swift
//  Bounce
//
//  Created by Bounce Team on 12/8/14.
//  Copyright (c) 2014 NYUPoly. All rights reserved.
//

import UIKit

class BounceHomeViewController: BounceBaseViewController {
    
    @IBOutlet weak var bouncePointLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var kingLabel: UILabel!
    @IBOutlet weak var nearestCourtLabel: UILabel!
    @IBOutlet weak var scoreImage: UIImageView!
    @IBOutlet weak var kingImage: UIImageView!
    @IBOutlet weak var closestCourtImage: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var offlabel: UILabel!
    @IBOutlet weak var defLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var userEmail: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Background image
        
        self.view.backgroundColor =
            UIColor(patternImage: UIImage(named: "background-home")!) // add ! mark if it does not compile
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setLogoutButton()
        self.hideBackButton()
        self.hideNavBar()
        self.setTitleText("Home")
        self.prepareHomeView()
    }
    
    @IBAction func gotNextButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("homeToCourtSegue", sender: self)
    }
    
    func prepareHomeView() -> Void {
        let userData: NSDictionary! = BounceJSONDataStore.getUserDetails(self.userEmail!) as NSDictionary!
        if (userData != nil) {
            self.bouncePointLabel.text = userData.valueForKey("bpoint") as? String
            self.scoreLabel.text = userData.valueForKey("avtivity") as? String
            self.kingLabel.text = userData.valueForKey("title") as? String
            self.nearestCourtLabel.text = userData.valueForKey("recent") as? String // TODO : Should be the image
            self.firstNameLabel.text = userData.valueForKey("fName") as? String
            self.lastNameLabel.text = userData.valueForKey("lName") as? String
            self.hashLabel.text = userData.valueForKey("hash") as? String
            self.heightLabel.text = userData.valueForKey("hgt") as? String
            self.weightLabel.text = userData.valueForKey("wgt") as? String
            self.ageLabel.text = userData.valueForKey("age") as? String
            self.offlabel.text = userData.valueForKey("off") as? String
            self.defLabel.text = userData.valueForKey("def") as? String
            self.ratingLabel.text = userData.valueForKey("rating") as? String
            
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let courtsController: BounceCourtsViewController = segue.destinationViewController as BounceCourtsViewController
        courtsController.userEmail = self.userEmail
    }
}
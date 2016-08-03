//
//  BounceCourtDetailsViewController.swift
//  Bounce
//
//  Created by Bounce Team on 12/9/14.
//  Copyright (c) 2014 NYUPoly. All rights reserved.
//

import UIKit

class BounceCourtDetailsViewController: BounceBaseViewController, UITableViewDelegate, UITableViewDataSource {

    var userEmail:String!
    var courtDetails:NSDictionary!
    var userList:NSArray!
    
    @IBOutlet weak var courtNameLabel: UILabel!
    @IBOutlet weak var openHourLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userListTable.delegate = self
        self.userListTable.dataSource = self
        let userCellNib:UINib = UINib(nibName: "BounceUserListTableViewCell", bundle: nil)
        self.userListTable.registerNib(userCellNib, forCellReuseIdentifier: "userListCell")
        self.userList = BounceJSONDataStore.getUserList(self.userEmail)
        println(self.userList)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setLogoutButton()
        self.setTitleText("Courts Details")
        self.courtNameLabel.text = self.courtDetails.valueForKey("courtname") as? String
        self.openHourLabel.text = self.courtDetails.valueForKey("openhours") as? String
        self.descriptionLabel.text = self.courtDetails.valueForKey("description") as? String
    }
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var defaultUserCell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("userListCell") as? UITableViewCell
        var customUserCell:BounceUserListTableViewCell! = nil
        if (defaultUserCell == nil) {
            customUserCell =
                NSBundle.mainBundle().loadNibNamed("userListCell", owner: self, options: nil).first as BounceUserListTableViewCell
        } else if(defaultUserCell? is BounceUserListTableViewCell) {
            customUserCell = defaultUserCell as BounceUserListTableViewCell
        }
        let user:NSDictionary = self.userList.objectAtIndex(indexPath.row) as NSDictionary
        customUserCell!.userNameLabel.text = (user.valueForKey("fname") as String) + " " + (user.valueForKey("lname") as String)
        return customUserCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userList != nil {
            return self.userList.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // In simulator we don't have email app installed, so could not
        // test the email sending, hence just an alert message
        // self.sendEmailInvitation()
        
        self.showInvitationAlert()
    }
    
    func sendEmailInvitation() {
        /* create mail subject */
        let subject:String = "Subject";
        
        /* define email address */
        let mail:String = "test@test.com";
        
        let mailString:String = "mailto:?to=\(mail)&subject=\(subject)"
        
        /* create the URL */
        let url:NSURL = NSURL(string: mailString)!
        
        /* load the URL */
        UIApplication.sharedApplication().openURL(url)
    }
    
    func showInvitationAlert() {
        let alert = UIAlertController(title: "Invitation Sent", message: "May be sometime later", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

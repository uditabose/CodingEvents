//
//  BounceCourtsViewController.swift
//  Bounce
//
//  Created by Bounce Team on 12/8/14.
//  Copyright (c) 2014 NYUPoly. All rights reserved.
//

import UIKit
import MapKit

class BounceCourtsViewController: BounceBaseViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var userEmail:String!
    var clLocationManager:CLLocationManager!
    var userCourtDetails: NSArray!
    var userCurrentLocation:MKUserLocation!
    let userLongitude:CLLocationDegrees = -73.985367
    let userLatitude:CLLocationDegrees = 40.6945678
    

    @IBOutlet weak var courtsMapView: MKMapView!
    @IBOutlet weak var courtInfoTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib:UINib = UINib(nibName: "BounceCourtInfoTableCell", bundle: nil)
        self.courtInfoTableView.registerNib(cellNib, forCellReuseIdentifier: "courtInfoCell")
        self.userCourtDetails = BounceJSONDataStore.getUserCourtData(self.userEmail) as NSArray!
        self.courtsMapView!.delegate = self
        self.courtInfoTableView!.delegate = self
        self.courtInfoTableView!.dataSource = self
        
        if (self.clLocationManager == nil) {
            self.clLocationManager = CLLocationManager()
        }
        if (CLLocationManager.locationServicesEnabled()) {
            println("location service is enabled")
            
            self.clLocationManager!.requestWhenInUseAuthorization()
            self.clLocationManager!.delegate = self
            self.clLocationManager!.desiredAccuracy = kCLLocationAccuracyKilometer

            // Set a movement threshold for new events.
            self.clLocationManager.distanceFilter = 500; // meters
            self.clLocationManager.startMonitoringSignificantLocationChanges()
            
            self.courtsMapView!.showsUserLocation = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.userEmail = nil
        self.clLocationManager = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setLogoutButton()
        self.setTitleText("Courts")
        self.prepareCourtView()
    }
    
    func prepareCourtView() -> Void {
        if (self.userCourtDetails != nil) {
            mapCoordinates(userCourtDetails)
        }
    }
    
    func mapCoordinates(parksArray:NSArray!) {
        if (parksArray == nil){
            print("No park coordinates\n")
            return
        }

        for park in parksArray {
            let parkMap = park as NSDictionary
            let latitude:CLLocationDegrees = (parkMap.valueForKey("coordN") as Double)
            let longitude:CLLocationDegrees = (parkMap.valueForKey("coordW") as Double)
            
            let location = CLLocationCoordinate2D (
                latitude: latitude,
                longitude: longitude
            )
            
            let span = MKCoordinateSpanMake(0.8, 0.8)
            let region = MKCoordinateRegionMake(location, span)
            
            self.courtsMapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.setCoordinate(location)
            annotation.title = parkMap.valueForKey("courtname") as NSString
            self.courtsMapView.addAnnotation(annotation)
        }
    }
    
    //MARK: - Map and Location View
    
    func mapViewWillStartLocatingUser(mapView: MKMapView!) {
        self.userCurrentLocation = mapView.userLocation
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println(locations)
    }
    
    
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.userCourtDetails != nil) {
            return self.userCourtDetails.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let courtSummaryCell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("courtInfoCell") as? UITableViewCell!
        var customCourtSummaryCell:BounceCourtInfoTableViewCell! = nil
        
        if (courtSummaryCell != nil) {
            if (courtSummaryCell? is BounceCourtInfoTableViewCell) {
                customCourtSummaryCell = courtSummaryCell as? BounceCourtInfoTableViewCell
            } else {
                customCourtSummaryCell = (NSBundle.mainBundle().loadNibNamed("courtInfoCell", owner: self, options: nil)).first as BounceCourtInfoTableViewCell
            }
            let courtData:NSDictionary! = userCourtDetails.objectAtIndex(indexPath.row) as? NSDictionary
            
            if (courtData != nil) {
                customCourtSummaryCell!.courtNameLabel.text = courtData.valueForKey("courtname") as NSString
                
                let latitude:CLLocationDegrees = (courtData.valueForKey("coordN") as Double)
                let longitude:CLLocationDegrees = (courtData.valueForKey("coordW") as Double)
                
                let parkLocation:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
                let userStation:CLLocation = CLLocation(latitude: self.userLatitude, longitude: self.userLongitude)
                let distance:CLLocationDistance = userStation.distanceFromLocation(parkLocation)
                
                var distStr:String = (distance/1000).description
                distStr = distStr.substringToIndex(advance(distStr.startIndex, 2))
                customCourtSummaryCell!.courtDistanceLabel.text = distStr + "km"
                customCourtSummaryCell!.tag = indexPath.row
            }
        }
        
        return customCourtSummaryCell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.courtDetailTapped(tableView.cellForRowAtIndexPath(indexPath))
    }
    

    func courtDetailTapped(sender:AnyObject!) {
        println(" courtDetailTapped cell tapped")
        performSegueWithIdentifier("courtInfoToDetailsSegue", sender: sender)
    }
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let courtData:NSDictionary! = userCourtDetails.objectAtIndex(sender.tag) as? NSDictionary
        
        let courtDetailsViewController:BounceCourtDetailsViewController = segue.destinationViewController as BounceCourtDetailsViewController
        courtDetailsViewController.courtDetails = courtData
        courtDetailsViewController.userEmail = self.userEmail

    }
}

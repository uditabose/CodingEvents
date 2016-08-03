//
//  BounceJSONDataStore.swift
//  Bounce
//
//  Created by Bounce Team on 12/9/14.
//  Copyright (c) 2014 NYUPoly. All rights reserved.
//

import Foundation

class BounceJSONDataStore: NSObject {
    
    class func readData(jsonPath:String, fileType:String) -> String! {
        let systemFilePath:String! = NSBundle.mainBundle().pathForResource(jsonPath, ofType: fileType)
        let fileData:String! = String(contentsOfFile: systemFilePath, encoding: NSUTF8StringEncoding, error: nil)!
        // If enternter error, try one of these:
        // let fileData:String! = String(contentsOfFile: systemFilePath, encoding: NSUTF8StringEncoding, error: nil)!
        // let fileData:String = String.stringWithContentsOfFile(systemFilePath, encoding: NSUTF8StringEncoding, error: nil)!
        return fileData
    }
    
    class func getAllUsers() -> NSArray! {
        let userData:NSArray! = BounceJSONUtil.parseJSONdata(readData("BouncePlayers", fileType: "json"))! as NSArray
        return userData
    }
    
    class func validateUserData(userEmail:String, password:String?) -> Bool {
        let users:NSArray! = getAllUsers()
        if userEmail == "" {
            return false
        }
        
        for user in users {
            let userDict:NSDictionary = user as NSDictionary
            if (userDict.valueForKey("username") as NSString) == userEmail {
                return true
            } else if (userDict.valueForKey("facebook") as NSString) == userEmail {
                return true
            }
        }

        return false
    }
    
    class func getUserDetails(userEmail:String) -> NSDictionary! {
        if userEmail == "" {
            return nil
        }
        
        let users:NSArray! = getAllUsers()
        
        for user in users {
            let userDict:NSDictionary = user as NSDictionary
            let userName:String = userDict.valueForKey("username") as NSString
            let facebook:String = userDict.valueForKey("facebook") as NSString
            if (userName == userEmail
                    || facebook == userEmail) {
                return userDict
            }
        }
        
        return nil
    }
    
    class func getUserCourtData(userEmail:String) -> NSArray! {
        var userCourtsData: NSArray! = BounceJSONUtil.parseJSONdata(readData("BounceCourts", fileType: "json"))! as NSArray
        println(userCourtsData)
        return userCourtsData
    }
    
    class func getUserList(userEmail:String!) -> NSArray! {
        return getAllUsers()
    }
    
}
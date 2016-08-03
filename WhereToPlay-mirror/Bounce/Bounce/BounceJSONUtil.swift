//
//  BounceJSONUtil.swift
//  Bounce
//
//  Created by Bounce Team on 12/11/14.
//  Copyright (c) 2014 NYUPoly. All rights reserved.
//

import Foundation

class BounceJSONUtil: NSObject {
    
    class func parseJSONdata(jsonDataString:String!) -> AnyObject? {
        if (jsonDataString != nil) {
            var jsonData: NSData = jsonDataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            return NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
        }
        return nil
    }
}

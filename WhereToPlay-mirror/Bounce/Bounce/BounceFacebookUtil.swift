//
//  BounceFacebookUtil.swift
//  Bounce
//
//  Created by Bounce Team on 12/9/14.
//  Copyright (c) 2014 NYUPoly. All rights reserved.
//

import Foundation

protocol BounceFacebookLoginHandler {
    func onSuccess() -> Void
    func onFailure() -> Void
}

class BounceFacebookUtil: NSObject {
    
    var delegate:BounceFacebookLoginHandler?
    
    override init() {
        // nothing to do
    }

    func sessionStateChanged(session:FBSession, state:FBSessionState, error:NSError!) -> Void {
        // do something
        if (error == nil && state == FBSessionState.Open) {
            println("Session opened")
            delegate!.onSuccess()
            return
        }
        
        if ((error) != nil) {
            println("Error occured during Facebook Login")
            FBSession.activeSession().closeAndClearTokenInformation()
            delegate!.onFailure()
        }
    }
}



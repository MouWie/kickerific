//
//  Match.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation

import UIKit
import Parse

class Match : PFObject, PFSubclassing {
    
    @NSManaged var team1Score: NSNumber
    @NSManaged var team2Score: NSNumber
    @NSManaged var Team1: Team
    @NSManaged var Team2: Team
    @NSManaged var finished: Bool
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Match"
    }
}
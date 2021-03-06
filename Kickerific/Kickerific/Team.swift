//
//  Team.swift
//  Kickerific
//
//  Created by Mario Auernheimer on 17.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Team: PFObject, PFSubclassing {

    @NSManaged var Player1: Player?
    @NSManaged var Player2: Player?
    @NSManaged var teamName: String
    @NSManaged var Wins: NSNumber?
    @NSManaged var Losses: NSNumber?
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Team"
    }

}

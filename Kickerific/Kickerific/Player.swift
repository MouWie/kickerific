//
//  Player.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit
import Parse

class Player : PFObject, PFSubclassing {
    
    @NSManaged var userID: String
    @NSManaged var name: String
    @NSManaged var numberOfWins: NSNumber
    @NSManaged var numberOfDefeat: NSNumber
    @NSManaged var numberOfGames: NSNumber
    @NSManaged var kickerPoints: NSNumber
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Player"
    }
}
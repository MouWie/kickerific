//
//  Challenge.swift
//  Kickerific
//
//  Created by Mario on 18.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation

import Foundation

import UIKit
import Parse

class Challenge : PFObject, PFSubclassing {
    
    // @NSManaged var players: Array<Player> later for more people
    @NSManaged var accepted: Bool
    @NSManaged var challenger: Player
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Challenge"
    }
}
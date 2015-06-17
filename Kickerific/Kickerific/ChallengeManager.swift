//
//  ChallengeManager.swift
//  Kickerific
//
//  Created by Mario on 17.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation
import Parse

@objc class ChallengeManager: ChallengeProtocol {
    
    func broadcastChallenge() {
        
        let userManager = ServiceLocator.sharedInstance.get(UserManagerProtocol) as! UserManager
        let player: Player = userManager.getCurrentPlayer()!
        
        let push = PFPush()
        push.setChannel("ChallengeAnyone")
        push.setMessage("i wanna play kicker: \(player.name)")
        push.sendPushInBackgroundWithBlock { (sucess, error) -> Void in
            
        }
        
    }
    
    func challengePlayer(player: Player) {
        
        let userManager = Managers.User
        //retreive the corresponding user from Cloud
        userManager.getUserWithID(player.userID, finished: { (user) -> () in
            let pushQuery = PFInstallation.query()
            pushQuery!.whereKey("user", equalTo: user)
            // Send push notification to query
            let push = PFPush()
            push.setQuery(pushQuery) // Set our Installation query
            push.setMessage("Hello \(player.name)! Accept my Kicker Challenge? Or weak? =)")
            push.sendPushInBackgroundWithBlock { (success, error) -> Void in
                println("push send")
            }
        })
    }
    
    func challengePlayers(players: Array<Player>) {
        
    }
}
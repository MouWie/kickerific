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
    
    var challenges: Array<Challenge>?
    
    func initialize() {
        
        challenges = getChallenges()
        
    }
    
    func broadcastChallenge() {
        
        let userManager = ServiceLocator.sharedInstance.get(UserManagerProtocol) as! UserManager
        let player: Player = userManager.getCurrentPlayer()!
        
        let push = PFPush()
        push.setChannel("ChallengeAnyone")
        push.setMessage("i wanna play kicker: \(player.name)")
        push.sendPushInBackgroundWithBlock { (sucess, error) -> Void in
            
        }
        
    }
    
    func getChallenges()->Array<Challenge>? {
        
        let query = PFQuery(className:"Challenge")
        query.fromLocalDatastore()
        challenges = query.findObjects() as? Array<Challenge>
        
        return challenges
    }
    
    
    func challengePlayers(players: Array<Player>) {
    
    }

    
    func challengePlayer(player:Player) {
        
        let userManager = Managers.User
        //retreive the corresponding user from Cloud
        userManager.getUserWithID(player.userID, finished: { (user) -> () in
            let pushQuery = PFInstallation.query()
            pushQuery!.whereKey("user", equalTo: user)
            // Send push notification to query
            let push = PFPush()
            let data = [
                "alert" : "Hello \(player.name)! \(userManager.getCurrentPlayer()!.name) wants to challenge you! Are you ready? =)",
                "badge" : "Increment",
                "p": userManager.getCurrentPlayer()!.objectId! as String
            ]
            push.setData(data)
            push.setQuery(pushQuery) // Set our Installation query
            push.sendPushInBackgroundWithBlock { (success, error) -> Void in
                println("push send to \(player.name)")
            }
        })
    }
    
    func acceptChallenge(challenge:Challenge) {
        
        let userManager = Managers.User
        //retreive the corresponding user from Cloud
        userManager.getUserWithID(challenge.challenger.userID, finished: { (user) -> () in
            let pushQuery = PFInstallation.query()
            pushQuery!.whereKey("user", equalTo: user)
            // Send push notification to query
            let push = PFPush()
            let data = [
                "alert" : "Challenge ACCEPTED by \(userManager.getCurrentPlayer()!.name)! BRING IT ON!",
                "badge" : "Increment",
                "c": challenge.objectId! as String
            ]
            push.setData(data)
            push.setQuery(pushQuery) // Set our Installation query
            push.sendPushInBackgroundWithBlock { (success, error) -> Void in
                println("push send to challenger")
            }
        })
    }
    
    func denyChallenge(challenge:Challenge) {
        
        let userManager = Managers.User
        //retreive the corresponding user from Cloud
        userManager.getUserWithID(challenge.challenger.userID, finished: { (user) -> () in
            let pushQuery = PFInstallation.query()
            pushQuery!.whereKey("user", equalTo: user)
            // Send push notification to query
            let push = PFPush()
            let data = [
                "alert" : "Challenge DENIED by \(userManager.getCurrentPlayer()!.name)! Maybe he is scared...",
                "badge" : "Increment",
            ]
            push.setData(data)
            push.setQuery(pushQuery) // Set our Installation query
            push.sendPushInBackgroundWithBlock { (success, error) -> Void in
                println("push send to challenger")
            }
        })
    }
    
    func createChallenge(player:Player) -> Challenge {
        
        let challenge = Challenge()
        challenge.challenger = player
        challenge.pin()
        challenges?.append(challenge)
        
        return challenge
    }
    
    func deleteChallengesFromChallenger(player: Player) {
        
        let query = PFQuery(className:"Challenge")
        query.fromLocalDatastore()
        query.whereKey("player", equalTo: player)
        
        let array = query.findObjects()
        
        for (var index = 0; index < array!.count; index++) {
            
            let obj: Challenge = array![index] as! Challenge
            obj.unpin()
            
        }
    }
    
    func deleteChallenge(challenge: Challenge) {
        
        let challenge = Challenge(withoutDataWithObjectId: challenge.objectId)
        
        challenge.unpin()
    }
    
}
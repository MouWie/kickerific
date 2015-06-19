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
        println(challenges?.count)
        UIApplication.sharedApplication().applicationIconBadgeNumber = challenges!.count
        //self.dumpChallenges()
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
    
    func getChallenges() -> Array<Challenge>? {
        
        let query = PFQuery(className:"Challenge")
        query.fromLocalDatastore()
        challenges = query.findObjects() as? Array<Challenge>
        
        return challenges
    }
    
    func getChallengedPlayers() -> Array<Player> {
        
        var arr:Array = [Player]()
        
        for var i = 0; i < challenges?.count; ++i {
            let player = challenges![i].defender
            arr.append(player)
        }
        return arr
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
                self.createChallenge(userManager.getCurrentPlayer()!, defender: player)
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
                "i" : "accepted",
                "ip" : userManager.getCurrentPlayer()!.objectId!
            ]
            push.setData(data)
            push.setQuery(pushQuery) // Set our Installation query
            push.sendPushInBackgroundWithBlock { (success, error) -> Void in
                println("ACCEPT CHALLENGE PUSH SEND")
                UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber - 1
                self.deleteChallengesFromChallenger(challenge.challenger, finished: { (finished) -> () in
                    
                })
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
                "i" : "denied",
                "ip" : userManager.getCurrentPlayer()!.objectId!
            ]
            push.setData(data)
            push.setQuery(pushQuery) // Set our Installation query
            push.sendPushInBackgroundWithBlock { (success, error) -> Void in
                println("DENY CHALLENGE PUSH SEND")
                UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber - 1
                self.deleteChallengesFromChallenger(challenge.challenger, finished: { (finished) -> () in
                    
                })
            }
        })
    }
    
    func createChallenge(challenger:Player, defender:Player) -> Challenge {
        
        let userManager = Managers.User
        let challenge = Challenge()
        challenge.challenger = challenger
        challenge.defender = defender
        challenge.pin()
        challenges?.append(challenge)
        
        return challenge
    }
    
    func deleteChallengesFromChallenger(player: Player, finished:(finished:Bool) -> ()) {
        
        let query = PFQuery(className:"Challenge")
        query.fromLocalDatastore()
        query.whereKey("challenger", equalTo: player)
        query.findObjectsInBackgroundWithBlock { (arr, error) -> Void in
            
            println(arr!.count)
            for (var index = 0; index < arr!.count; index++) {
                let obj: Challenge = arr![index] as! Challenge
                println("Challenge from Challenger removed: \(self.challenges![index].challenger)")
                obj.unpin()
            }
            
            self.challenges = self.getChallenges()
            finished(finished: true)
        }

    }
    
    func dumpChallenges() {
        
        let query = PFQuery(className:"Challenge")
        query.fromLocalDatastore()
        
        let array = query.findObjects()
        println(array)
        println(array?.count)
        
        for (var index = 0; index < array!.count; index++) {
            let obj: Challenge = array![index] as! Challenge
            obj.unpin()
        }
        self.challenges?.removeAll(keepCapacity: true)
        
    }
    
    func deleteChallenge(challenge: Challenge) {
        let challenge = Challenge(withoutDataWithObjectId: challenge.objectId)
        challenge.unpin()
    }
}
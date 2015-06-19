//
//  UserManager.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation
import Parse

@objc class UserManager: UserManagerProtocol {
    
    var _currentPlayer: Player?
    var _currentUser: PFUser?
    
    func initialize(finished: (Bool) -> ()) {
        _currentUser = getCurrentUser() as? PFUser
        findPlayerForUser(_currentUser!.objectId!, finished: { (player) -> () in
            self._currentPlayer = player
            
            // Associate the device with a user, do it just if not done yet
            let installation = PFInstallation.currentInstallation()
            
            if (installation["user"] == nil){
                installation["user"] = PFUser.currentUser()
                installation.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if(error != nil) {
                        installation.saveEventually(nil)
                        finished(true)
                    }
                    else {
                        finished(true)
                    }
                })
            }
            else if (installation["user"] is NSNull) {
                installation["user"] = PFUser.currentUser()
                installation.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if(error != nil) {
                        installation.saveEventually(nil)
                        finished(true)
                    }
                    else {
                        finished(true)
                    }
                })
            }
            else {
               finished(true)
            }

        })
    }
    
    func loginUserWithPass(username: String, password: String, finished: (NSError?)->()) {
        
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                finished(nil)
            } else {
                // The login failed. Check error to see why.
                let error = NSError(domain: error!.domain, code: error!.code, userInfo: error!.userInfo)
                finished(error)
            }
        }
        
    }
    
    
    func saveNewPlayer() -> Player {
        
        let currentUser = PFUser.currentUser()
        let player = Player()
        player.userID = currentUser!.objectId!
        player.name = PFUser.currentUser()!.username!
        player.numberOfDefeat = 0
        player.numberOfWins = 0
        player.kickerPoints = 0
        player.saveInBackgroundWithBlock { (bool, error) -> Void in
            if(error != nil){
                player.saveEventually({ (success, error) -> Void in
                    if(error == nil) {
                        self._currentPlayer = player
                        println("new Player saved: \(player.name)")
                    }
                })
            }
            else {
                self._currentPlayer = player
                println("new Player saved: \(player.name)")
            }
        }
        
        return player
    }
    
    func logoutUser() {
        
        PFUser.logOut()
        _currentUser = PFUser.currentUser()
        let installation = PFInstallation.currentInstallation()
        installation["user"] = NSNull()
        installation.save()
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    func getCurrentUser() -> AnyObject? {
        
        if _currentUser != nil {
            // Do stuff with the user
            
            return _currentUser!
        }
        return PFUser.currentUser()
    }
    
    func getCurrentPlayer() -> Player? {
        
        if((_currentPlayer) != nil) {
            return _currentPlayer!
        }
        else {
          return nil
        }
    }
    
    func findPlayerForUser(userID: String, finished:(Player)->()) {
        
        var currentUser = PFUser.currentUser()
        var query = PFQuery(className:"Player")
        query.whereKey("userID", equalTo:userID)
        let array = query.findObjects()
        if (array?.count > 0) {
            finished(array?.first as! Player)
        }
        else {
            finished(self.saveNewPlayer())
        }
    }
    
    func findPlayerWithID(playerID: String, finished:(Player)->()) {
        
        var query = PFQuery(className:"Player")
        query.whereKey("objectId", equalTo:playerID)
        let array = query.findObjects()
        if (array?.count > 0) {
            finished(array?.first as! Player)
        }
    }
    
    func updatePlayerStats() {
        
        
        
    }
    
    func getPlayerList() -> Array<Player> {
        var query = PFQuery(className: "Player")
        query.orderByAscending("name")
        let array: Array<Player> = query.findObjects() as! Array<Player>
        return array
        
    }
    
    func getUserWithID(idString: String, finished: (PFObject) -> ()) {
        var query = PFUser.query()
        
        query!.getObjectInBackgroundWithId(idString) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                finished(user!)
            } else {
                println(error)
            }
        }
    }
    
}
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
            finished(true)
        })
        
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
    
    
    func updatePlayerStats() {
        
        
        
    }
    
    func getPlayerList() -> Array<Player> {
        var query = PFQuery(className: "Player")
        query.orderByAscending("name")
        let array: Array<Player> = query.findObjects() as! Array<Player>
        return array
        
    }
    

    
}
//
//  UserManagerProtocol.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation
import Parse

@objc protocol UserManagerProtocol {
    
    /**
    *  Initialize Service
    */
    func initialize(finished:(Bool)->())
    
    /**
    *  login user
    */
    func loginUserWithPass(username: String, password: String, finished: (NSError?)->())
    
    /**
    *  logout user, reset current
    */
    func logoutUser()
    
    /**
    *  save new Player instance, called when registrating the user
    */
    
    func saveNewPlayer() -> Player
    
    /**
    *  get current User
    */
    func getCurrentUser () -> AnyObject?
    
    /**
    *  get the player object for the user
    */
    
    func findPlayerForUser(userID: String, finished:(Player)->())
    
    /**
    *  get the player
    */
    
    func findPlayerWithID(playerID: String, finished:(Player)->())
    
    
    /**
    *  func get currentPlayer
    */
    func getCurrentPlayer()->Player?
    
    /**
    *  get list of registered Players
    */
    
    func getPlayerList() -> Array<Player>
    
    /**
    *  get a user with id
    */
    func getUserWithID(idString: String, finished:(PFObject)->())
}
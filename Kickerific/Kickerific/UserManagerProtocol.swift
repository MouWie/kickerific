//
//  UserManagerProtocol.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation

@objc protocol UserManagerProtocol {
    
    /**
    *  Initialize Service
    */
    func initialize(finished:(Bool)->())
    
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
    *  get user player
    */
    
    func findPlayerForUser(userID: String, finished:(Player)->())
    
    
    /**
    *  func get currentPlayer
    */
    func getCurrentPlayer()->Player?
    
    /**
    *  get list of registered users
    */
    
    func getPlayerList() -> Array<Player>
    
}
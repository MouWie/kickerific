//
//  ChallengeProtocol.swift
//  Kickerific
//
//  Created by Mario on 17.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation

@objc protocol ChallengeProtocol {
    /**
    *  initialize the manager with properties
    */
    func initialize()
    
    /**
    *  Boradcast to all registered Users
    */
    func broadcastChallenge()
    
    /**
    *  Send Challenge to secific Player
    */
    func challengePlayer(player:Player)
    
    /**
    *  Broadcast to specific players
    */
    func challengePlayers(players:Array<Player>)
    
    /**
    *  Creates a new challenge with a player
    */
    
    func createChallenge(player:Player) -> Challenge
}
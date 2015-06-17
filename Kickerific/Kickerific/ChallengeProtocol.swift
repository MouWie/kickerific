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
}
//
//  GameManagerProtocol.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation


@objc protocol GameManagerProtocol {
    
    /**
    *  Initialize
    */
    func initialize()
    
    
    /**
    *  Creates a game locally
    */
    func createLocalGame(team1: Team, team2: Team)
    
    /**
    *  Creats a game remotely
    */
    
    func createRemoteGame(team1: Team, team2: Team)
    
    /**
    *  Create a team from array
    */
    func createTeamFromArray(arr:Array<Player>) -> Team
}
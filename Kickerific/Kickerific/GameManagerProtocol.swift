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
    *  Creates game
    */
    
    func createGame(finished:(Bool) -> ())
    
    /**
    *  Create a team from array
    */
    func createTeamFromArray(arr:Array<Player>) -> Team
}
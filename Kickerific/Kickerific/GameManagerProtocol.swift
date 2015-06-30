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
    *  get list of all matches
    */
    func getMatchList() -> Array<Match>
    
    /**
    *  get matchList for Current Player
    */
    func getPlayerMatchList() -> Array<Match>
    
    /**
    *  refreshes matchList
    */
    func refreshMatches()
    
    /**
    *  Creates a new game
    */
    
    func createGame(team1: Team, team2: Team, finished:(Bool) -> ())
    
    /**
    *  Creates a team object from array
    */
    func createTeamFromArray(arr:Array<Player>) -> Team
    
    /**
    *  saves/updates a game remote in database
    */
    func saveRemoteGame(match: Match, finished: (Bool) -> ())
}
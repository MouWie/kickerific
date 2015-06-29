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
    *  get MatchList for Current Player
    */
    func getPlayerMatchList() -> Array<Match>
    
    /**
    *  refrseshes matchList
    */
    func refreshMatches()
    
    /**
    *  Creates game
    */
    
    func createGame(team1: Team, team2: Team, finished:(Bool) -> ())
    
    /**
    *  Create a team from array
    */
    func createTeamFromArray(arr:Array<Player>) -> Team
    
}
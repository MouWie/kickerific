//
//  RankingManager.swift
//  Kickerific
//
//  Created by Mario Auernheimer on 08.07.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation
import Parse

@objc class RankingManager: RankingProtocol {
    
    func getPlayerScoreRanking() -> Array<Player> {
        var query = PFQuery(className: "Player")
        query.orderByDescending("kickerPoints")
        let playerList = query.findObjects() as? Array<Player>
        return playerList!
    }
    
    func getPlayerWinRanking() -> Array<Player> {
        var query = PFQuery(className: "Player")
        query.orderByDescending("numberOfWins")
        let playerList = query.findObjects() as? Array<Player>
        return playerList!
    }
    
    func getTeamScoreRanking() -> Array<Team> {
        var query = PFQuery(className: "Team")
        query.orderByDescending("Wins")
        let teamsArray = query.findObjects() as? Array<Team>
        return teamsArray!
    }
    
    func getMostGamesRanking() -> Array<Player> {
        var query = PFQuery(className: "Player")
        query.orderByDescending("numberOfGames")
        let playerList = query.findObjects() as? Array<Player>
        return playerList!
    }
    
    func getWorstTeamRanking() -> Array<Team> {
        var query = PFQuery(className: "Team")
        query.orderByAscending("Losses")
        let teamsArray = query.findObjects() as? Array<Team>
        return teamsArray!
    }
    
    
    
}
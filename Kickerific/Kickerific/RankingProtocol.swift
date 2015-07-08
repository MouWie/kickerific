//
//  RankingProtocol.swift
//  Kickerific
//
//  Created by Mario Auernheimer on 08.07.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation



@objc protocol RankingProtocol {
    
    func getPlayerScoreRanking() -> Array<Player>
    
    func getTeamScoreRanking() ->Array<Team>
    
    func getMostGamesRanking() -> Array<Player>
    
    func getWorstTeamRanking() -> Array<Team>
    
    func getPlayerWinRanking() -> Array<Player>
}
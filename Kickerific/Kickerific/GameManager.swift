//
//  GameManager.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//
import Foundation
import Parse

class GameManager: NSObject, GameManagerProtocol {
    
    var matchList: Array<Match>?
    
    func initialize() {
        
        var query = PFQuery(className: "Match")
        let array: Array<Match> = query.findObjects() as! Array<Match>
        matchList = array
    }
    
    
    func createLocalGame(team1: Team, team2: Team) {
       
        
    }
    
    func createRemoteGame(team1: Team, team2: Team) {
        
        let match = Match()
        match.Team1 = team1
        match.Team2 = team2
        match.team1Score = 0
        match.team2Score = 0
        match.finished = false
        
        match.saveInBackgroundWithBlock { (success, error) -> Void in
            
            self.getMatchListFromRemote()
            
        }
        
    }
    
    func getMatchListFromRemote() {
        
        var query = PFQuery(className: "Match")
        let array: Array<Match> = query.findObjects() as! Array<Match>
        matchList = array
        
    }
    
    func getLocalMatchList() {
        
        
        
    }
    
    func createTeamFromArray(arr:Array<Player>) -> Team{
        
        let team = Team()
        
        let count = arr.count
        
        if(count > 0) {
            
            if(count == 1) {
                team.player1 = arr[0]
            }
            if(count == 2) {
                team.player1 = arr[0]
                team.player2 = arr[1]
            }
        }
        
        return team
    }
    
    
    
}

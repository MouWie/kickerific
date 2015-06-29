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
    var playerMatchList: Array<Match>?
    
    func initialize() {
        let userManager = Managers.User
        matchList = getMatchListFromRemote(false)
        playerMatchList = getPlayerMatchList()
    }
    
    func refreshMatches() {
        
        playerMatchList = nil
        playerMatchList = getPlayerMatchList()
        
    }
    
    
    func createLocalGame(team1: Team, team2: Team) -> Match {
       
        let match = Match()
        match.Team1 = team1
        match.Team2 = team2
        match.team1Score = 0
        match.team2Score = 0
        match.finished = false
        
        return match
    }
    
    
    func saveRemoteTeam(team: Team) -> Team? {
        
        let saved = team.save()
        
        if(saved) {
           return team
        }
        else {
            return nil
        }
    }
    
    func saveRemoteGame(match: Match, finished: (Bool) -> ()) {
        
        match.saveInBackgroundWithBlock { (success, error) -> Void in
            
            if(success) {
                finished(true)
            }
            else {
                finished(false)
            }
        }
        
    }
    
    func createGame(team1: Team, team2: Team, finished:(Bool) -> ()) {
        
        let p_team1: Team?
        if let savedteam1 = getTeamForPlayers(team1.Player1, player2: team1.Player2) {
            p_team1 = savedteam1
        }
        else {
            p_team1 = saveRemoteTeam(team1)
        }
        
        let p_team2: Team?
        if let savedteam2 = getTeamForPlayers(team2.Player1, player2: team2.Player2) {
            p_team2 = savedteam2
        }
        else {
            p_team2 = saveRemoteTeam(team2)
        }
        
        let match = createLocalGame(p_team1!, team2: p_team2!)
        saveRemoteGame(match, finished: { (success) -> () in
            // reload match List
            self.matchList = self.getMatchListFromRemote(false)
            if(success) {
                finished(true)
            }
            else {
                finished(false)
            }
        })
    }
    
    func closeGame(match: Match, finished:(Bool) -> ()) {
        
        match.finished = true
        match.saveInBackgroundWithBlock { (success, error) -> Void in
            
        }
    }
    
    func getMatchListFromRemote(finished: Bool) -> Array<Match> {
        
        var query = PFQuery(className: "Match")
        query.whereKey("finished", equalTo: NSNumber(bool: finished))
        let array: Array<Match> = query.findObjects() as! Array<Match>
        
        return array
        
    }
    
    func getMatchListForTeamFromRemote(team:Team, finished: Bool) -> Array<Match> {
        
        var query = PFQuery(className: "Match")
        query.whereKey("finished", equalTo: NSNumber(bool: finished))
        query.whereKey("Team1", equalTo: team)
        query.whereKey("finished", equalTo: NSNumber(bool: finished))
        var array: Array<Match> = query.findObjects() as! Array<Match>
        
        var query2 = PFQuery(className: "Match")
        query2.whereKey("Team2", equalTo: team)
        query2.whereKey("finished", equalTo: NSNumber(bool: finished))
        
        let array2: Array<Match> = query2.findObjects() as! Array<Match>
        
        array.extend(array2);
        
        return array
        
    }
    
    func getMatchList() -> Array<Match> {
        
        if(matchList != nil) {
            return matchList!
        }
        else {
            matchList = getMatchListFromRemote(false)
            return matchList!
        }
    }
    
    func getPlayerMatchList() -> Array<Match> {
        
        if(playerMatchList != nil) {
            return playerMatchList!
        }
        else {
            let userManager = Managers.User
            
            let teamsArray:Array<Team> = getTeamsForPlayer(userManager.getCurrentPlayer()!)
            var resultsArray: Array<Match> = []
            
            for team in teamsArray {
                
                let arr = getMatchListForTeamFromRemote(team, finished: false)
                resultsArray.extend(arr)
            }
            
            playerMatchList = resultsArray
            
            return playerMatchList!
        }
    }
    
    func getLocalMatchList() -> Array<Match> {
        
        var query = PFQuery(className: "Match")
        query.fromLocalDatastore()
        let array: Array<Match> = query.findObjects() as! Array<Match>
        
        return array
    }
    
    func getTeamsForPlayer(player:Player) -> Array<Team> {
        
        var query = PFQuery(className: "Team")
        query.whereKey("Player1", equalTo: player)
        var array: Array<Team> = query.findObjects() as! Array<Team>
        
        var query2 = PFQuery(className: "Team")
        query.whereKey("Player2", equalTo: player)
        let array2: Array<Team> = query.findObjects() as! Array<Team>
        array.extend(array2)
        
        return array
    }
    
    func getTeamForPlayers(player1:Player?, player2: Player?) ->Team? {
        
        var query = PFQuery(className: "Team")
        if let playerOne = player1 {
            query.whereKey("Player1", equalTo: playerOne)
        }
        else {
            query.whereKeyDoesNotExist("Player1")
        }
        
        if let playerTwo = player2 {
            query.whereKey("Player2", equalTo: player2!)
        }
        else{
            query.whereKeyDoesNotExist("Player2")
        }
        
        if let object = query.getFirstObject() as? Team {
            return object
        }
        else {
            return nil
        }
    }
    
    func getTeamFromRemote(player1: Player, player2: Player) -> Team? {
        
        var query = PFQuery(className: "Team")
        query.whereKey("Player1", equalTo: player1)
        query.whereKey("Player2", equalTo: player2)
        let array: Array<Team> = query.findObjects() as! Array<Team>
        
        if(array.count > 0) {
            return array[0]
        }
        else {
            return nil
        }
    }
    
    func createTeamFromArray(arr:Array<Player>) -> Team{
        
        let team = Team()
        
        let count = arr.count
        
        if(count > 0) {
            
            if(count == 1) {
                team.Player1 = arr[0]
                team.teamName = team.Player1!.name
            }
            if(count == 2) {
                team.Player1 = arr[0]
                team.Player2 = arr[1]
            }
            team.teamName = "\(team.Player1!.name)"+"/"+"\(team.Player1!.name)"
        }
        
        return team
    }
    
    
    
}

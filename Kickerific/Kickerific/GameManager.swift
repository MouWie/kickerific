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
        matchList = getMatchListFromRemote()
    }
    
    func refreshMatches() {
        
        PFObject.fetchAllIfNeeded(matchList)
        
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
    
    func getTeamForPlayers(player1:Player, player2: Player) ->Team? {
        
        var query = PFQuery(className: "Team")
        query.whereKey("Player1", equalTo: player1)
        query.whereKey("Player2", equalTo: player2)
        
        if let object = query.getFirstObject() as? Team {
            return object
        }
        else {
            return nil
        }
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
            match.pin()
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
        if let savedteam1 = getTeamForPlayers(team1.Player1!, player2: team1.Player2!) {
            p_team1 = savedteam1
        }
        else {
            p_team1 = saveRemoteTeam(team1)
        }
        
        let p_team2: Team?
        if let savedteam2 = getTeamForPlayers(team2.Player1!, player2: team2.Player2!) {
            p_team2 = savedteam2
        }
        else {
            p_team2 = saveRemoteTeam(team2)
        }
        
        let match = createLocalGame(p_team1!, team2: p_team2!)
        saveRemoteGame(match, finished: { (success) -> () in
            self.matchList = self.getMatchListFromRemote()
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
    
    func getMatchListFromRemote() -> Array<Match> {
        
        var query = PFQuery(className: "Match")
        query.whereKey("finished", equalTo: NSNumber(bool: false))
        let array: Array<Match> = query.findObjects() as! Array<Match>
        
        return array
        
    }
    
    func getMatchList() -> Array<Match> {
        
        if(matchList != nil) {
            return matchList!
        }
        else {
            return getMatchListFromRemote()
        }
    }
    
    func getLocalMatchList() -> Array<Match> {
        
        var query = PFQuery(className: "Match")
        query.fromLocalDatastore()
        let array: Array<Match> = query.findObjects() as! Array<Match>
        
        return array
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

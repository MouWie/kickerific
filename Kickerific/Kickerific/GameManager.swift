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
    
    
    func saveRemoteTeam(team: Team, finished: (Bool) -> ()){
        
        team.saveInBackgroundWithBlock { (success, error) -> Void in
            
            if (success) {
                finished(true)
            }
            else {
                finished(false)
            }
            
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
        
        // TO FIX 
        let p_team1: Team?
        if let savedteam1 = getTeamForPlayers(team1.Player1, player2: team1.Player2) {
            p_team1 = savedteam1
            
            let p_team2: Team?
            if let savedteam2 = getTeamForPlayers(team2.Player1, player2: team2.Player2) {
                p_team2 = savedteam2
                let match = self.createLocalGame(team1, team2: p_team2!)
                self.saveRemoteGame(match, finished: { (success) -> () in
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
            else {
                saveRemoteTeam(team2, finished: { (success) -> () in
                    let match = self.createLocalGame(team1, team2: team2)
                    self.saveRemoteGame(match, finished: { (success) -> () in
                        // reload match List
                        self.matchList = self.getMatchListFromRemote(false)
                        if(success) {
                            finished(true)
                        }
                        else {
                            finished(false)
                        }
                    })
                })
            }

        }
        else {
            saveRemoteTeam(team1, finished: { (success) -> () in
                let p_team2: Team?
                if let savedteam2 = self.getTeamForPlayers(team2.Player1, player2: team2.Player2) {
                    p_team2 = savedteam2
                    let match = self.createLocalGame(team1, team2: p_team2!)
                    self.saveRemoteGame(match, finished: { (success) -> () in
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
                else {
                    self.saveRemoteTeam(team2, finished: { (success) -> () in
                        let match = self.createLocalGame(team1, team2: team2)
                        self.saveRemoteGame(match, finished: { (success) -> () in
                            // reload match List
                            self.matchList = self.getMatchListFromRemote(false)
                            if(success) {
                                finished(true)
                            }
                            else {
                                finished(false)
                            }
                        })
                    })
                }

            })
        }
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
    
    func setTeamNameForTeam(team: Team) {
        
        let teamName: String?
        
        if(team.Player1 != nil) {
            team.teamName = "\(team.Player1!.name)"+"/"+"\(team.Player1!.name)"
            
            if(team.Player2 != nil) {
                team.teamName = "\(team.Player1!.name)"+"/"+"\(team.Player2!.name)"
            }
        }

    }
    
    func validateFinishedMatch(match: Match) {
        
        match.ACL = PFACL(user: PFUser.currentUser()!)
        match.Team1.ACL = PFACL(user: PFUser.currentUser()!)
        match.Team2.ACL = PFACL(user: PFUser.currentUser()!)
        
        
        let team1 = match.Team1
        let team2 = match.Team2
        
        //increment winning team, decrement loosing team
        if (match.team1Score.integerValue > match.team2Score.integerValue) {
            
            team1.incrementKey("Wins")
            team1.Player1?.incrementKey("numberOfWins")
            team1.Player2?.incrementKey("numberOfWins")
            
            team2.incrementKey("Losses", byAmount: NSNumber(integer: -1))
            team2.Player1?.incrementKey("Losses", byAmount: NSNumber(integer: -1))
            team2.Player2?.incrementKey("Losses", byAmount: NSNumber(integer: -1))
            
        }
        else if (match.team1Score.integerValue < match.team2Score.integerValue) {
            team1.incrementKey("Losses")
            team1.Player1?.incrementKey("Losses", byAmount: NSNumber(integer: -1))
            team1.Player2?.incrementKey("Losses", byAmount: NSNumber(integer: -1))
            
            team2.incrementKey("Wins")
            team2.Player1?.incrementKey("numberOfWins")
            team2.Player2?.incrementKey("numberOfWins")
        }
        
        refreshScorePointsForPlayer(team1.Player1!)
        refreshScorePointsForPlayer(team1.Player2!)
        
        refreshScorePointsForPlayer(team2.Player1!)
        refreshScorePointsForPlayer(team2.Player2!)
        match.save()
    }
    
    func refreshScorePointsForPlayer(player: Player) {
        
        let newScore = player.numberOfWins.integerValue - player.numberOfDefeat.integerValue
        player.kickerPoints = NSNumber(integer: newScore)
        player.ACL = PFACL(user: PFUser.currentUser()!)
        player.save()
    }
    
    func fetchObject(obj: PFObject?) -> PFObject {
        
        if let object = obj {
            let pfacl = PFACL(user: PFUser.currentUser()!)
            pfacl.setReadAccess(true, forUser: PFUser.currentUser()!)
            obj?.ACL = pfacl
            obj?.fetchIfNeeded()
            
        }
        return obj!
    }
}

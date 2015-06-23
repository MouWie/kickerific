//
//  ChallengeViewController.swift
//  Kickerific
//
//  Created by Mario on 18.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    
    var _challenge: Challenge?
    var _challengeManager: ChallengeProtocol?
    
    init(challenge: Challenge) {
        _challenge = challenge
        _challengeManager = Managers.Challenge
        super.init(nibName: "ChallengeViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = "Challenge received from\(_challenge!.challenger.name)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func denyChallenge(sender: AnyObject) {
        
        _challengeManager?.deleteChallenge(_challenge!)
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            // notify challenger
            _challengeManager?.denyChallenge(_challenge!)
        })
    }
    
    
    @IBAction func acceptChallenge(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            //notify challenger
            self._challengeManager?.acceptChallenge(self._challenge!)
            
            //start match making 
            
            let gameManager = Managers.Game
            let userManager = Managers.User
            // Create the game
            var team1Array: [Player] = [userManager.getCurrentPlayer()!]
            var team2Array: [Player] = [self._challenge!.challenger]
            
            let team1 = gameManager.createTeamFromArray(team1Array)
            let team2 = gameManager.createTeamFromArray(team2Array)
            
            gameManager.createGame(team1, team2: team2, finished: { (success) -> () in
                if(success) {
                    gameManager.refreshMatches()
                    NSNotificationCenter.defaultCenter().postNotificationName("gameUpdate", object: nil)
                }
            })
            
        })
    }
}

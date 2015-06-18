//
//  ChallengeViewController.swift
//  Kickerific
//
//  Created by Mario on 18.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {
    
    var _challenge: Challenge?
    
    init(challenge: Challenge) {
        _challenge = challenge
        super.init(nibName: "ChallengeViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        
    }
    
    
    @IBAction func acceptChallenge(sender: AnyObject) {
        
        
    }
}
//
//  TabBarViewController.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit
import Parse

class TabBarViewController: UITabBarController {

    @IBOutlet weak var welcomeLabel: UILabel!
    var userManager: UserManagerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //user must be logged in now
        userManager = ServiceLocator.sharedInstance.get(UserManagerProtocol) as! UserManager
        let currentUser:PFUser = userManager?.getCurrentUser() as! PFUser
        
        let challengeManager = Managers.Challenge
        let gameManager = Managers.Game
        
        welcomeLabel.text = "Hello \(currentUser.username!)! Ready to play?"
        
        // Initialize Items
        
        let items = self.tabBar.items as NSArray!
        var tabItem = items.objectAtIndex(0) as! UITabBarItem
        tabItem.badgeValue = "\(challengeManager.getChallengedPlayers().count)"
        
        var tabItem2 = items.objectAtIndex(1) as! UITabBarItem
        tabItem2.badgeValue = "\(gameManager.getPlayerMatchList().count)"
        
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationItem.hidesBackButton = true
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

    @IBAction func logoutUser(sender: AnyObject) {
        
        userManager?.logoutUser()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}

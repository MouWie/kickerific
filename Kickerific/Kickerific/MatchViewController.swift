//
//  MatchViewController.swift
//  Kickerific
//
//  Created by Mario on 23.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit

class MatchViewController: UITableViewController{
    
    let gameManager = Managers.Game
    let userManager = Managers.User
    var matchList: Array<Match>?
    var selectedMatch: Match?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matchList = gameManager.getMatchList()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationArrived:", name: "matchUpdate", object: nil)
        
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(animated: Bool) {
        if let parent = self.parentViewController as? UITabBarController {
            
            self.tabBarItem.badgeValue = "\(matchList!.count)"
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return gameManager.getMatchList().count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("matchCell", forIndexPath: indexPath) as! MatchTableViewCell
        cell.tag = indexPath.row
        let currentMatch = matchList![indexPath.row] as Match
        
        
        let team: Team = currentMatch.Team1.fetchIfNeeded() as! Team
        
        cell.teamname1?.text = team.teamName
        
        let team2: Team = currentMatch.Team2.fetchIfNeeded() as! Team
        
        cell.teamname2?.text = team2.teamName

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMatch = matchList![indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editMatchController: EditMatchViewController = storyboard.instantiateViewControllerWithIdentifier("EditMatchViewController") as! EditMatchViewController
        editMatchController.match = selectedMatch
        self.presentViewController(editMatchController, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "EditMatchSegue") {
            let destController = segue.destinationViewController as! EditMatchViewController
            destController.match = selectedMatch
        }
    }
    */
    
    func notificationArrived(notification: NSNotification) {
        
        gameManager.refreshMatches()
        self.tableView.reloadData()
        
    }
    

}

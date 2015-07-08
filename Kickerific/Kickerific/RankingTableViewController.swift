//
//  RankingTableViewController.swift
//  Kickerific
//
//  Created by Mario Auernheimer on 08.07.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit

class RankingTableViewController: UITableViewController {
    
    let rankingManager = Managers.Ranking
    var playerScoreArray: Array<Player>?
    var mostWinsArray: Array<Player>?
    var mostGamesArray: Array<Player>?
    var bestTeamArray: Array<Team>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        playerScoreArray = rankingManager.getPlayerScoreRanking()
        mostGamesArray = rankingManager.getMostGamesRanking()
        mostWinsArray = rankingManager.getPlayerWinRanking()
        bestTeamArray = rankingManager.getTeamScoreRanking()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if(section == 0) {
            return playerScoreArray!.count
        }
        else if(section == 1) {
            return mostGamesArray!.count
            
        }
        else if(section == 2) {
            return mostWinsArray!.count
        }
        else if(section == 3) {
            return bestTeamArray!.count
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        if (indexPath.section == 0) {
            var player = playerScoreArray![indexPath.row] as Player
            cell.textLabel?.text = "\(indexPath.row + 1). "+player.name
        }
        if (indexPath.section == 1) {
            var player = mostGamesArray![indexPath.row] as Player
            cell.textLabel?.text = "\(indexPath.row + 1). "+player.name
        }
        if (indexPath.section == 2) {
            var player = mostWinsArray![indexPath.row] as Player
            cell.textLabel?.text = "\(indexPath.row + 1). "+player.name
        }
        if (indexPath.section == 3) {
            var team = bestTeamArray![indexPath.row] as Team
            cell.textLabel?.text = "\(indexPath.row + 1). "+team.teamName
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Best Players"
        }
        else if(section == 1) {
            return "Active Players"
        }
        else if(section == 2) {
            return "Most Wins"
        }
        else if(section == 3) {
            return "Best Teams"
        }
        return "Makes no sense"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

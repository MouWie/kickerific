//
//  PlayerTableViewController.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit
import Parse

class PlayerTableViewController: UITableViewController {
    
    var userManager: UserManagerProtocol?
    var challengeManager: ChallengeProtocol?
    var playerArray: Array<Player>?
    var challengedPlayerArray: Array<Player>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userManager = ServiceLocator.sharedInstance.get(UserManagerProtocol) as! UserManager
        self.challengeManager = ServiceLocator.sharedInstance.get(ChallengeProtocol) as! ChallengeManager
        
        playerArray = userManager?.getPlayerList()
        challengedPlayerArray = challengeManager?.getChallengedPlayers()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationArrived:", name: "notifciationArrived", object: nil)
        
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(animated: Bool) {
        if let parent = self.parentViewController as? UITabBarController {
            
            self.tabBarItem.badgeValue = "\(challengedPlayerArray!.count)"
            
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
        return playerArray!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
         let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        challengedPlayerArray = challengeManager?.getChallengedPlayers()
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.contentView.backgroundColor = UIColor.grayColor()//getRandomColor()
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.imageView?.image = UIImage(named: "maxresdefault")
        let player = playerArray![indexPath.row] as Player
        let text = player.name
        cell.textLabel?.text = text
        if (text == PFUser.currentUser()?.username) {
            // if current user
            cell.userInteractionEnabled = false
            cell.contentView.backgroundColor = UIColor.darkGrayColor()
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.text = "You"
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
            cell.imageView?.image = UIImage(named: "funnycat")
        }
        else {
            // check if there are already open challenges
            if let players = challengedPlayerArray {
                for player in players {
                    if cell.textLabel?.text == player.name {
                        cellDeactivated(cell)
                    }
                }
            }
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // send push to receiver
        let playerToChallenge = playerArray![indexPath.row] as Player
        challengeManager?.challengePlayer(playerToChallenge)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cellDeactivated(cell!)
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
    
    func cellDeactivated(cell:UITableViewCell) {

        //cell.userInteractionEnabled = false
        cell.alpha = 0.8
        cell.detailTextLabel?.text = "challenged"
        //cell.userInteractionEnabled = false
        
    }
    
    func cellReActivated(cell:UITableViewCell, text:String) {
        
        cell.alpha = 1
        cell.detailTextLabel?.text = text
        cell.userInteractionEnabled = true
    }
    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }

    @IBAction func challengeBroadcast(sender: AnyObject) {
        challengeManager?.broadcastChallenge()
    }
    
    func notificationArrived(notification: NSNotification) {
        
        self.tableView.reloadData()
        
    }

}

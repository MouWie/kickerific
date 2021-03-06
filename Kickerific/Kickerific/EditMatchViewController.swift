
//
//  EditMatchViewController.swift
//  Kickerific
//
//  Created by Mario Auernheimer on 24.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit
import Parse

class EditMatchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    var userManager:UserManagerProtocol = Managers.User
    var gameManager:GameManagerProtocol = Managers.Game
    var userList: Array<Player>?
    var match: Match?
    @IBOutlet weak var score1TextField: UITextField!
    
    @IBOutlet weak var score2TextField: UITextField!
    
    @IBOutlet weak var picker1: UIPickerView!
    @IBOutlet weak var picker2: UIPickerView!
    @IBOutlet weak var picker3: UIPickerView!
    @IBOutlet weak var picker4: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userList = userManager.getPlayerList()
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        prepareSliders()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        
        self.view.endEditing(true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //  MARK: - Picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userList!.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let players = userList!
        
        return players[row].name
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 75
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
     }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = "myString"
        let players = userList!
        return NSAttributedString(string: players[row].name, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    
    func prepareSliders() {
        
        let playerlist = userManager.getPlayerList()
        
        for (var i = 0; i < playerlist.count; ++i) {
            
            let player = playerlist[i]
            
            if let pl1 = self.match!.Team1.Player1 {
                gameManager.fetchObject(pl1)
                if(player.name == self.match?.Team1.Player1?.name) {
                    // set first slider
                    picker1.selectRow(i, inComponent: 0, animated: true)
                }
            }
            
            if let pl2 = self.match!.Team1.Player2 {
                gameManager.fetchObject(pl2)
                if(player.name == self.match?.Team1.Player2?.name) {
                    //set second slider
                    picker2.selectRow(i, inComponent: 0, animated: true)
                }
            }
            
            if let pl3 = self.match!.Team2.Player1 {
                gameManager.fetchObject(pl3)
                
                if(player.name == self.match?.Team2.Player1?.name) {
                    //set third slider
                    picker3.selectRow(i, inComponent: 0, animated: true)
                }
            }
            
            if let pl4 = self.match!.Team2.Player2 {
                gameManager.fetchObject(pl4)
                
                if (player.name == self.match?.Team2.Player2?.name) {
                    //set fourth slider
                    picker4.selectRow(i, inComponent: 0, animated: true)
                    
                }
            }
        }
    }
    
    //MARK: Actions
    
    
    @IBAction func dismissView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func save(sender: AnyObject) {
        saveMatch { (finished) -> () in
            if (finished) {
                self.dismissViewControllerAnimated(true, completion: nil)
                //self.gameManager.validateFinishedMatch(self.match!)
                NSNotificationCenter.defaultCenter().postNotificationName("matchUpdate", object: nil)
            }
            else {
                self.match?.saveEventually()
                //self.gameManager.validateFinishedMatch(self.match!)
                self.dismissViewControllerAnimated(true, completion: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("matchUpdate", object: nil)
            }
            
        }
    }
    
    func saveMatch(block:(ready:Bool)->()) {
        self.match?.Team1.Player1 = userList![picker1.selectedRowInComponent(0)]
        self.match?.Team1.Player2 = userList![picker2.selectedRowInComponent(0)]
        self.match?.Team2.Player1 = userList![picker3.selectedRowInComponent(0)]
        self.match?.Team2.Player2 = userList![picker4.selectedRowInComponent(0)]
        
        let score1 = score1TextField.text.toInt()
        self.match?.team1Score = NSNumber(integer: score1!)
        let score2 = score2TextField.text.toInt()
        self.match?.team2Score = NSNumber(integer: score2!)
        
        gameManager.setTeamNameForTeam(match!.Team1)
        gameManager.setTeamNameForTeam(match!.Team2)
        
        gameManager.validateFinishedMatch(match!)
        
        self.match?.finished = true
        match?.saveInBackgroundWithBlock({ (success, error) -> Void in
            if(error == nil) {
                block(ready: true)
            }
            else {
                block(ready: false)
            }
            
        })
        
        
    }

}

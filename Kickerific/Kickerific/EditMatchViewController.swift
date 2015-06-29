//
//  EditMatchViewController.swift
//  Kickerific
//
//  Created by Mario Auernheimer on 24.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit

class EditMatchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    var userManager:UserManagerProtocol = Managers.User
    var match: Match?
    @IBOutlet weak var score1TextField: UITextField!
    
    @IBOutlet weak var score2TextField: UITextField!
    
    @IBOutlet weak var picker1: UIPickerView!
    @IBOutlet weak var picker2: UIPickerView!
    @IBOutlet weak var picker3: UIPickerView!
    @IBOutlet weak var picker4: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        prepareSliders()
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
    
    //  MARK: - Picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userManager.getPlayerList().count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let players = userManager.getPlayerList()
        
        return players[row].name
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 75
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    
    func prepareSliders() {
        
        let playerlist = userManager.getPlayerList()
        
        for (var i = 0; i < playerlist.count; ++i) {
            
            let player = playerlist[i]
            if(player.name == self.match?.Team1.Player1?.name) {
                // set first slider
                picker1.selectRow(i, inComponent: 0, animated: true)
            }
            else if(player.name == self.match?.Team1.Player2?.name) {
                //set second slider
                picker2.selectRow(i, inComponent: 0, animated: true)
            }
            
            if(player.name == self.match?.Team2.Player1?.name) {
                //set third slider
                picker3.selectRow(i, inComponent: 0, animated: true)
            }
            else if (player.name == self.match?.Team1.Player2?.name) {
                //set fourth slider
                picker4.selectRow(i, inComponent: 0, animated: true)
                
            }
            
        }

        
        
    }
    
    //MARK: Actions
    
    
    @IBAction func dismissView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func save(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
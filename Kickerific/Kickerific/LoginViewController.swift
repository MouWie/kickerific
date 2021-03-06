//
//  LoginViewController.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    var userManager: UserManagerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.hidesBackButton = true
        userManager = ServiceLocator.sharedInstance.get(UserManagerProtocol) as! UserManager
 
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //check for logged in user
        var currentUser: AnyObject? = userManager?.getCurrentUser()
        if currentUser is PFUser {
            // Do stuff with the user
            
            userManager?.initialize({ (finished) -> () in
                if(finished) {
                   self.navigationController!.performSegueWithIdentifier("loginSegue", sender: nil)
                    //Initialize Challenge Manager, get already stored challanges
                    let challengeManager = Managers.Challenge
                    challengeManager.initialize()
                    
                    //Initialize Game Manager, get already stored matches
                    let gameManager = Managers.Game
                    gameManager.initialize()
                }
            })
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "loginSegue") {
            
            
        }
    }
    
    func dismissKeyboard() {
        
        self.view.endEditing(true)
        
    }
    

    
    @IBAction func login(sender: AnyObject) {
        
        userManager?.loginUserWithPass(usernameTextField.text, password: passwordTextField.text, finished: { (error) -> () in
            if(error != nil) {
                let alert:UIAlertController = UIAlertController(title: "Login failed", message: "Something wrong with your credentials", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    println(action)
                }
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                self.userManager?.initialize({ (finished) -> () in
                    if(finished) {
                        self.navigationController!.performSegueWithIdentifier("loginSegue", sender: sender)
                        
                        //Initialize Challenge Manager, get already stored challanges
                        let challengeManager = Managers.Challenge
                        challengeManager.initialize()
                        
                        //Initialize Game Manager, get already stored matches
                        let gameManager = Managers.Game
                        gameManager.initialize()
                    }
                })
            }
        })
    }
}

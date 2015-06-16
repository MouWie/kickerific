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
        
        userManager = ServiceLocator.sharedInstance.get(UserManagerProtocol) as! UserManager
 
        // Do any additional setup after loading the view.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        var currentUser: AnyObject? = userManager?.getCurrentUser()
        if currentUser is PFUser {
            // Do stuff with the user
            userManager?.initialize({ (finished) -> () in
                if(finished) {
                   self.performSegueWithIdentifier("loginSegue", sender: nil)
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
    
    
    
    @IBAction func login(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password:passwordTextField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                self.userManager?.initialize({ (finished) -> () in
                    if(finished) {
                       self.performSegueWithIdentifier("loginSegue", sender: sender)
                    }
                })
            } else {
                // The login failed. Check error to see why.
                let alert:UIAlertController = UIAlertController(title: "Login failed", message: "Something wrong with your credentials", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    println(action)
                }
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
        
    }
}

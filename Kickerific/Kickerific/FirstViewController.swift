//
//  FirstViewController.swift
//  Kickerific
//
//  Created by Mario on 15.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit
import Parse

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let parent = self.parentViewController as? UITabBarController {
            
            self.tabBarItem.badgeValue = nil
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


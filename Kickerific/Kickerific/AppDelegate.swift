//
//  AppDelegate.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit

import Bolts
import Parse

// If you want to use any of the UI components, uncomment this line
// import ParseUI

// If you want to use Crash Reporting - uncomment this line
// import ParseCrashReporting

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Bootstrapper.initializeServices()
        Bootstrapper.initializeParseFunctions()
        
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()
        
        // ****************************************************************************
        // Uncomment this line if you want to enable Crash Reporting
        // ParseCrashReporting.enable()
        //
        // Uncomment and fill in with your Parse credentials:
        Parse.setApplicationId("2wSGYWfYCqX0XnYcLejBkir6myjagnbbiQvbbiYC", clientKey: "2Ff9CvHUhN34hFbxGgbpV0Wz4k7Qb5tI3enpwSng")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************
        
        //PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.setPublicReadAccess(true)
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
            application.registerForRemoteNotifications()
        }
        
        //User Notification if app running
        
        if let notificationPayload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            
            handleNotification(notificationPayload)
            
        }
        
        return true
    }
    
    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
        PFPush.subscribeToChannelInBackground("ChallengeAnyone", block: { (succeeded: Bool, error: NSError?) -> Void in
            if succeeded {
                println("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
            } else {
                println("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.", error)
            }
        })
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        handleNotification(userInfo)
        (UIBackgroundFetchResult.NoData)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
        
    }
    
    func handleNotification(userInfo: NSDictionary) {
        
        let userManager = Managers.User
        let challengeManager = Managers.Challenge
        let gameManager = Managers.Game
        // get the player Object
        
        // notification comes in as challenge
        if let player: AnyObject = userInfo["p"] {
           
            let playerID = userInfo["p"] as? String
            
            userManager.findPlayerWithID(playerID!, finished: { (player) -> () in
                let challenge = challengeManager.createChallenge(player, defender: userManager.getCurrentPlayer()!)
                let viewController = ChallengeViewController(challenge: challenge)
                let navController = self.window?.rootViewController as! UINavigationController
                navController.visibleViewController.presentViewController(viewController, animated: true, completion: nil)
            })

        } // notification comes in as answer
        else {
            
            if let info: AnyObject = userInfo["i"] {
                let player = userInfo["ip"] as! String
                if info as! String == "accepted" {
                    // challenge accepted -> find opponent player in player list
                    userManager.findPlayerWithID(player, finished: { (object) -> () in
                        let player = object
                        let navController = self.window?.rootViewController as! UINavigationController
                        
                        let visibleViewController = navController.visibleViewController
                        if(visibleViewController is UITabBarController) {
                            
                            // delete the challenges and create match
                            challengeManager.deleteChallengesFromChallenger(userManager.getCurrentPlayer()!, finished: { (finished) -> () in
                                let alert = UIAlertController(title: "New Matchup! ", message: "\(player.name) accepted your challenge. Good luck!", preferredStyle: UIAlertControllerStyle.Alert)
                                let cancelAction = UIAlertAction(title: "Will do", style: .Cancel) { (action) in
                                    println(action)
                                }
                                alert.addAction(cancelAction)
                                let tabcontroller = navController.visibleViewController as! UITabBarController
                                tabcontroller.presentViewController(alert, animated: true, completion: nil)
                                var tabArray = tabcontroller.tabBar.items as NSArray!
                                var tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
                                tabItem.badgeValue = "New"
                                
                                NSNotificationCenter.defaultCenter().postNotificationName("gameUpdate", object: nil)
                                NSNotificationCenter.defaultCenter().postNotificationName("challengeUpdate", object: nil)
                            })
                        }
                        
                    })
                }
                else {
                    // challenge denied
                    userManager.findPlayerWithID(player, finished: { (object) -> () in
                        let player = object
                        
                        challengeManager.deleteChallengesFromChallenger(userManager.getCurrentPlayer()!, finished: { (finished) -> () in
                            
                            let navController = self.window?.rootViewController as! UINavigationController
                            let visibleViewController = navController.visibleViewController
                            let alert = UIAlertController(title: "Challenge denied", message: "\(player.name) is scared of you!", preferredStyle: UIAlertControllerStyle.Alert)
                            let cancelAction = UIAlertAction(title: "Pussy", style: .Cancel) { (action) in
                                println(action)
                            }
                            alert.addAction(cancelAction)
                            visibleViewController.presentViewController(alert, animated: true, completion: nil)
                            
                            NSNotificationCenter.defaultCenter().postNotificationName("challengeUpdate", object: nil)
                        })
                        
                    })
                    
                }
                
            }
            
        }
        
    }
    
    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //     if application.applicationState == UIApplicationState.Inactive {
    //         PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    //     }
    // }
    
    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------
    
    ///////////////////////////////////////////////////////////
    // Uncomment this method if you are using Facebook
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    //     return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, session:PFFacebookUtils.session())
    // }
}

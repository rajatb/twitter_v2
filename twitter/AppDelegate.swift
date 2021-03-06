//
//  AppDelegate.swift
//  twitter
//
//  Created by Rajat Bhargava on 9/24/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import UIColor_Hex_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        customAppearance()
        
        if User.currentUser != nil {
            print("There is a current user")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let hamburgerVC = storyBoard.instantiateViewController(withIdentifier: "hamburgerVC") as! HamburgerViewController
            let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            
            menuVC.hamburgerVC = hamburgerVC
            hamburgerVC.menuVC = menuVC
            
            
            //let vc = storyBoard.instantiateViewController(withIdentifier: "TweetsNavigationController")
            window?.rootViewController = hamburgerVC
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil, queue: OperationQueue.main) { (notification: Notification) in
            print("logout yay!")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateInitialViewController()
            
            UIView.transition(with: self.window!, duration: 0.3, options: .transitionFlipFromTop, animations: {
                self.window?.rootViewController = vc
            }, completion: { completed in
                // maybe do something here
            })
            
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
       
        TwitterClient.sharedInstance.handleOpenUrl(url: url)
    
        return true
    }
    
    func customAppearance(){
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = UIColor("#326ada")
        navigationBarAppearace.tintColor = UIColor("#ffffff")
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName : UIColor("#ffffff")]
        
    }



}


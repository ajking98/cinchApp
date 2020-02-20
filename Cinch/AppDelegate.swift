//
//  AppDelegate.swift
//  Cinch
//
//  Created by Gedi, Ahmed M on 4/11/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        //checks if the user already exists, and if they do, they save the username to the global user defaults
        if let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) {
            print("Existing User")
            UserDefaults(suiteName: "group.InstagramClone.messages")?.set(username, forKey: defaultsKeys.usernameKey)
            print("here is your username: ", username)
            if UserDefaults.standard.string(forKey: defaultsKeys.stateOfUser) == nil {
                UserDefaults.standard.set("Signup/Login", forKey: defaultsKeys.stateOfUser)
            }
            let sign = UserDefaults.standard.string(forKey: defaultsKeys.stateOfUser)
            print(sign)
        }
        else {
            //TODO user should be constructed with a preset SuggestedContent list
            print("New User")
            let user = User()
            ParentStruct().addUser(user: user)
            print("here is your created username:", user.username)
            
            UserDefaults.standard.set(user.username, forKey: defaultsKeys.usernameKey)
            UserDefaults(suiteName: "group.InstagramClone.messages")?.set(user.username, forKey: defaultsKeys.usernameKey)
            UserDefaults.standard.set("Signup/Login", forKey: defaultsKeys.stateOfUser)

            //TODO add the other default values here as needed (Use a few user defaults as possible)
        }
//        UILabel.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "Marker felt"))
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


}


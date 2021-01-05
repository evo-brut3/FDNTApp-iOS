//
//  AppDelegate.swift
//  FDNT
//
//  Created by Konrad Startek on 17/09/2019.
//  Copyright © 2019 Konrad Startek. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize Firebase
        FirebaseApp.configure()

        // Clear tabs if user is not signed in
        if !FirebaseManager.shared.isSigned() {
            TabManager.CachedTabs.clearTabs()
        } else {
            
            // Add email tab if user has signed to mail account
            if let email = FirebaseManager.shared.userEmail {
                let key = KeychainWrapper.Key.init(rawValue: email)
                
                if let password = KeychainWrapper.standard.string(forKey: key) {
                    TabManager.DefaultTabs.enableEmailTab()
                    EmailManager.shared.connect(login: email, password: password, completion: { isLogged in
                    
                        // check if logged in
                        if isLogged == true {
                            
                            // success
                            EmailManager.shared.fetch()
                            
                            // show loading indicator in statusbar
                            
                        } else {
                            // failure
                            print("AppDelegate - failed to sign into email acccount with the credentials provided by the keychain")
                            TabManager.DefaultTabs.disableEmailTab()
                            KeychainWrapper.standard.remove(forKey: key)
                        }
                        
                    })
                }
            }
            
        }
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .fdntYellow
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

            UINavigationBar.appearance().tintColor = .fdntBlue
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().tintColor = .fdntBlue
            UINavigationBar.appearance().barTintColor = .fdntYellow
            UINavigationBar.appearance().isTranslucent = false
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


}


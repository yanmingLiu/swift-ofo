//
//  AppDelegate.swift
//  ofo_2
//
//  Created by lym on 2017/10/30.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

import UIKit

let AMapKey = "665dbea5d964ab9d119b72bdb32ec7f5"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AMapServices.shared().apiKey = AMapKey
        AMapServices.shared().enableHTTPS = true
        
        return true
    }

    // MARK: - applicationWillResignActive
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    // MARK: - applicationDidEnterBackground
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}


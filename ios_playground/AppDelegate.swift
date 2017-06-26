//
//  AppDelegate.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/19.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import UIKit
import XCGLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let value = launchOptions?[UIApplicationLaunchOptionsKey.location] as? Bool, value {
            
//            // バックグラウンドでもタグを探索するためにBackgroundTaskを立ち上げる
//            
//            self.backgroundTaskId = application.beginBackgroundTaskWithExpirationHandler() {
//                
//                application.endBackgroundTask(self.backgroundTaskId)
//                
//                self.backgroundTaskId = UIBackgroundTaskInvalid
//                
//            }
//            
//            // 位置情報関係で起動された場合は位置情報更新の開始、及びリージョン監視を開始後、画面起動せず終了
//            
//            MNBLEBeaconManager.sharedInstance.launchLocation()
            AppCentralManager.default.initLaunch()
            
            return true
        }
        
        // 通知権限要求
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        self.window?.makeKeyAndVisible()
        
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

let log: XCGLogger! = {
    #if DEBUG
        let log = XCGLogger.default
        log.setup(level: .verbose, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: .debug)
        return log
    #else
        return nil
    #endif
}()

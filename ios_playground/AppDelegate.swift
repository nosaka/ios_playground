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
    
    var viewsAreInitialized: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let value = launchOptions?[UIApplicationLaunchOptionsKey.location] as? Bool, value {
            BeaconCentralManager.default.initLaunch()
            return true
        }
        
        // 通知権限要求
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        // View初期化処理
        self.initializeViews()
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // View初期化処理
        self.initializeViews()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        realmHelper.log(beaconCentralManager: .terminateApplication)
    }
    
    /// View初期化処理
    func initializeViews() {
        if self.viewsAreInitialized {
            // View初期化済みの場合は処理しない
            return
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        self.window?.makeKeyAndVisible()
        
        self.viewsAreInitialized = true
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

let realmHelper: RealmHelper! = RealmHelper()

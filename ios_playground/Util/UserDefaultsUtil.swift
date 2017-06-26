//
//  UserDefaultsUtil.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/19.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
/// UserDefaults Keys
class UserDefaultsKey {
    static let startAdvertising = "keyStartAdvertising"
    static let startMonitoring = "keyStartMonitoring"
}
/// UserDefaults Utility
class UserDefaultsUtil {
    
    /// init
    private init() {
        // 生成禁止
        self.initialize()
    }
    
    /// 初期処理
    /// 各種設定のデフォルト値を登録する
    func initialize() {
        UserDefaults.standard.register(defaults: [UserDefaultsKey.startAdvertising : false,
                                                  UserDefaultsKey.startMonitoring : false])
    }
    
    /// アドバタイズフラグ
    class var advertising:Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.startAdvertising)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.startAdvertising)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// モニタリングフラグ
    class var monitoring:Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.startMonitoring)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.startMonitoring)
            UserDefaults.standard.synchronize()
        }
    }
    
    
}

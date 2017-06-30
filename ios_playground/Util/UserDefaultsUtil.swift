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
    static let startMonitoring = "keyStartMonitoring"
    static let updateLocation = "keyUpdateLocation"
    
    static let countOfBeaconInRegion = "keyCountOfBeaconInRegion"
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
        UserDefaults.standard.register(defaults: [UserDefaultsKey.startMonitoring : false,
                                                  UserDefaultsKey.updateLocation : false,
                                                  UserDefaultsKey.countOfBeaconInRegion : 0])
    }
    
    /// リージョンモニタリングフラグ
    class var monitoring:Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.startMonitoring)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.startMonitoring)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// 位置情報更新フラグ
    class var updateLocation:Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.updateLocation)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.updateLocation)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// リージョン内Beacon数
    class var countOfBeaconInRegion:Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKey.countOfBeaconInRegion)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.countOfBeaconInRegion)
            UserDefaults.standard.synchronize()
        }
    }
    
}

//
//  RealmHelper.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/28.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    
    /// Logging by BeaconCentralManagerLog
    func log(beaconCentralManager logType: BeaconCentralManagerLogType, notes:String? = nil) {
        let realm = try! Realm()
        let newItem = BeaconCentralManagerLog()
        try! realm.write {
            newItem.time = Date()
            newItem.logType = logType
            newItem.notes = notes
            realm.add(newItem)
        }
    }
    
    /// Logging by AppLocationManagerLog
    func log(appLocationManager logType: AppLocationManagerLogType, notes:String? = nil) {
        let realm = try! Realm()
        let newItem = AppLocationManagerLog()
        try! realm.write {
            newItem.time = Date()
            newItem.logType = logType
            newItem.notes = notes
            realm.add(newItem)
        }
    }
    
    func all<T: Object>(_ type: T.Type, sorted: (byKeyPath: String, ascending:Bool)? = nil) -> Results<T> {
        let realm = try! Realm()
        if let sorted = sorted {
            return realm.objects(type).sorted(byKeyPath: sorted.byKeyPath, ascending: sorted.ascending)
        }
        return realm.objects(type)
        
    }
    func delete<T: Object>(_ type: T.Type) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self.all(type))
        }
    }
}

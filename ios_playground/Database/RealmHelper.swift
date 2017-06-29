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
    
    /// Logging by CentralManagerLog
    func log(CentralManagerLog logType: CentralManagerLogType) {
        let realm = try! Realm()
        let newItem = CentralManagerLog()
        try! realm.write {
            newItem.time = Date()
            newItem.logType = logType
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

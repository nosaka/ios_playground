//
//  BeaconLog.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/28.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

/// CentralManagerLog
class CentralManagerLog: Object {
    
    dynamic var time:Date? = nil
    
    private dynamic var rawLogType:Int = CentralManagerLogType.unknown.valueAsRealm
    
    var logType: CentralManagerLogType {
        get {
            return CentralManagerLogType(rawValue: self.rawLogType) ?? .unknown
        }
        set {
            self.rawLogType = newValue.valueAsRealm
        }
    }
}
/// CentralManagerLog:logType
enum CentralManagerLogType: Int {
    case unknown
    case didDetermineStateInside
    case didDetermineStateOutside
    case didEnterRegion
    case didExitRegion
    
    var valueAsRealm: Int {
        get {
            return self.rawValue
            
        }
    }
    
    var localizable: String {
        get {
            switch self {
            case .unknown:
                return R.string.localizable.unknown()
            case .didDetermineStateInside:
                return R.string.localizable.didDetermineStateInside()
            case .didDetermineStateOutside:
                return R.string.localizable.didDetermineStateOutside()
            case .didEnterRegion:
                return R.string.localizable.didEnterRegion()
            case .didExitRegion:
                return R.string.localizable.didExitRegion()
            }
        }
    }
}


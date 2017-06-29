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
    
    static let defaultSortKey = "time"
    
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
    case launchByLocation
    case terminate
    case startMonitoring
    case stopMonitoring
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
            case .launchByLocation:
                return R.string.localizable.centralManagerLogType_launchByLocation()
            case .terminate:
                return R.string.localizable.centralManagerLogType_terminate()
            case .startMonitoring:
                return R.string.localizable.centralManagerLogType_startMonitoring()
            case .stopMonitoring:
                return R.string.localizable.centralManagerLogType_stopMonitoring()
            case .unknown:
                return R.string.localizable.centralManagerLogType_unknown()
            case .didDetermineStateInside:
                return R.string.localizable.centralManagerLogType_didDetermineStateInside()
            case .didDetermineStateOutside:
                return R.string.localizable.centralManagerLogType_didDetermineStateOutside()
            case .didEnterRegion:
                return R.string.localizable.centralManagerLogType_didEnterRegion()
            case .didExitRegion:
                return R.string.localizable.centralManagerLogType_didExitRegion()
            }
        }
    }
}


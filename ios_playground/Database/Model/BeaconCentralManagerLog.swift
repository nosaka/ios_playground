//
//  BeaconCentralManagerLog.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/28.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

/// BeaconCentralManagerLog
class BeaconCentralManagerLog: Object {
    
    static let defaultSortKey = "time"
    
    dynamic var time:Date? = nil
    
    private dynamic var rawLogType:Int = BeaconCentralManagerLogType.unknown.valueAsRealm
    
    var logType: BeaconCentralManagerLogType {
        get {
            return BeaconCentralManagerLogType(rawValue: self.rawLogType) ?? .unknown
        }
        set {
            self.rawLogType = newValue.valueAsRealm
        }
    }
}
/// BeaconCentralManagerLog:logType
enum BeaconCentralManagerLogType: Int {
    case unknown
    case launchByLocation
    case terminateApplication
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
            case .unknown:
                return R.string.localizable.beaconCentralManagerLogType_unknown()
            case .launchByLocation:
                return R.string.localizable.beaconCentralManagerLogType_launchByLocation()
            case .terminateApplication:
                return R.string.localizable.beaconCentralManagerLogType_terminateApplication()
            case .startMonitoring:
                return R.string.localizable.beaconCentralManagerLogType_startMonitoring()
            case .stopMonitoring:
                return R.string.localizable.beaconCentralManagerLogType_stopMonitoring()
            case .didDetermineStateInside:
                return R.string.localizable.beaconCentralManagerLogType_didDetermineStateInside()
            case .didDetermineStateOutside:
                return R.string.localizable.beaconCentralManagerLogType_didDetermineStateOutside()
            case .didEnterRegion:
                return R.string.localizable.beaconCentralManagerLogType_didEnterRegion()
            case .didExitRegion:
                return R.string.localizable.beaconCentralManagerLogType_didExitRegion()
            }
        }
    }
}


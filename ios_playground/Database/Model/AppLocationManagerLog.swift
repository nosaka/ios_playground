//
//  AppLocationManagerLog.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/29.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import RealmSwift

/// AppLocationManagerLog
class AppLocationManagerLog: Object {
    
    static let defaultSortKey = "time"
    
    dynamic var time:Date? = nil
    
    private dynamic var rawLogType:Int = AppLocationManagerLogType.unknown.valueAsRealm
    
    var logType: AppLocationManagerLogType {
        get {
            return AppLocationManagerLogType(rawValue: self.rawLogType) ?? .unknown
        }
        set {
            self.rawLogType = newValue.valueAsRealm
        }
    }
    
    dynamic var notes:String? = nil
}
/// AppLocationManagerLog:logType
enum AppLocationManagerLogType: Int {
    case unknown
    case launchByLocation
    case terminateApplication
    case startUpdateLocation
    case stopUpdateLocation
    case didUpdateLocations
    case didFailWithError
    case didPauseLocationUpdates
    case didResumeLocationUpdates
    case didFinishDeferredUpdatesWithError
    case didVisit
    
    var valueAsRealm: Int {
        get {
            return self.rawValue
            
        }
    }
    
    var localizable: String {
        get {
            switch self {
            case .unknown:
                return R.string.localizable.appLocationManagerLogType_unknown()
            case .launchByLocation:
                return R.string.localizable.appLocationManagerLogType_launchByLocation()
            case .terminateApplication:
                return R.string.localizable.appLocationManagerLogType_terminateApplication()
            case .startUpdateLocation:
                return R.string.localizable.appLocationManagerLogType_startUpdateLocation()
            case .stopUpdateLocation:
                return R.string.localizable.appLocationManagerLogType_stopUpdateLocation()
            case .didUpdateLocations:
                return R.string.localizable.appLocationManagerLogType_didUpdateLocations()
            case .didFailWithError:
                return R.string.localizable.appLocationManagerLogType_didFailWithError()
            case .didPauseLocationUpdates:
                return R.string.localizable.appLocationManagerLogType_didPauseLocationUpdates()
            case .didResumeLocationUpdates:
                return R.string.localizable.appLocationManagerLogType_didResumeLocationUpdates()
            case .didFinishDeferredUpdatesWithError:
                return R.string.localizable.appLocationManagerLogType_didFinishDeferredUpdatesWithError()
            case .didVisit:
                return R.string.localizable.appLocationManagerLogType_didVisit()
            }
        }
    }
}


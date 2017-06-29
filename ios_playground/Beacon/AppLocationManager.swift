//
//  AppLocationManager.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/29.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

class AppLocationManager: NSObject {
    
    static let `default` = AppLocationManager()
    
    var locationManager = CLLocationManager()
    
    var delegate: AppLocationManagerDelegate?
    
    /// init
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
    }
    
    /// ランチ時初期処理
    func initLaunch() {
        NotificationFactory.logging(.monitoredRegionWhenLaunch(self.locationManager)).notify()
    }
    
    /// 位置情報更新開始
    func startUpdateLocation() {
        
        let state = CLLocationManager.authorizationStatus()
        guard state == .authorizedAlways else {
            switch state {
            case .notDetermined:
                self.locationManager.requestAlwaysAuthorization()
            default:
                self.delegate?.requestLocationAlways()
                break
            }
            UserDefaultsUtil.monitoring = false
            return
        }
        UserDefaultsUtil.updateLocation = true
        self.locationManager.startUpdatingLocation()
//        realmHelper.log(CentralManagerLog: .startMonitoring)
    }
    
    /// 位置情報更新停止
    func stopUpdateLocation() {
        UserDefaultsUtil.updateLocation = false
//        realmHelper.log(CentralManagerLog: .stopMonitoring)
    }
    
}
/// AppLocationManagerDelegate
protocol AppLocationManagerDelegate: class {
    func requestLocationAlways()
}
/// AppLocationManager+CLLocationManagerDelegate
extension AppLocationManager: CLLocationManagerDelegate {
    
    @available(iOS 6.0, *)
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    @available(iOS 2.0, *)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    @available(iOS 6.0, *)
    public func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
    }
    
    @available(iOS 6.0, *)
    public func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
    }
    
    @available(iOS 6.0, *)
    public func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
    }
    
    @available(iOS 8.0, *)
    public func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    }


    
}


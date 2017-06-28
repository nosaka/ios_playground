//
//  AppCentralManager.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/22.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

class AppCentralManager: NSObject {

    static let `default` = AppCentralManager()
    
    var delegate: AppCentralManagerDelegate?
    
    var locationManager = CLLocationManager()
    
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
    
    /// モニタリング開始
    func startMonitoring() {
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
        UserDefaultsUtil.monitoring = true
        self.locationManager.startMonitoring(for: AppBeacon.beaconRegion)
    }
    
    /// モニタリング停止
    func stopMonitoring() {
        UserDefaultsUtil.monitoring = false
        self.locationManager.stopMonitoring(for: AppBeacon.beaconRegion)
    }
}
/// AppCentralManagerDelegate
protocol AppCentralManagerDelegate: class {
    func requestLocationAlways()
}
/// AppCentralManager+CLLocationManagerDelegate
extension AppCentralManager: CLLocationManagerDelegate {
    
    @available(iOS 7.0, *)
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        guard let region = region as? CLBeaconRegion else {
            return
        }
        switch state {
        case .inside:
            log.debug("didDetermineState inside")
            realmHelper.log(CentralManagerLog: .didDetermineStateInside)
            self.locationManager.startRangingBeacons(in: region)
        case .outside:
            log.debug("didDetermineState outside")
            realmHelper.log(CentralManagerLog: .didDetermineStateOutside)
            self.locationManager.stopRangingBeacons(in: region)
        default:
            break
        }
    }
    
    @available(iOS 4.0, *)
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        log.debug("didEnterRegion")
        realmHelper.log(CentralManagerLog: .didEnterRegion)
        NotificationFactory.enterRegion.notify()
    }
    
    @available(iOS 4.0, *)
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        log.debug("didExitRegion")
        realmHelper.log(CentralManagerLog: .didExitRegion)
        NotificationFactory.exitRegion.notify()
    }

}


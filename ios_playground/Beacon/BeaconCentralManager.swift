//
//  BeaconCentralManager.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/22.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

/// BeaconCentralManager
class BeaconCentralManager: NSObject {

    static let `default` = BeaconCentralManager()
    
    var delegate: BeaconCentralManagerDelegate?
    
    var locationManager = CLLocationManager()
    
    /// init
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
    }
    
    /// ランチ時初期処理
    func initLaunch() {
        realmHelper.log(beaconCentralManager: .launchByLocation,
                        notes: "monitoredRegions:=" + self.locationManager.monitoredRegions.count.description)
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
        if self.isMonitoring() {
            // 既に監視開始中の場合は以降の処理を実施しない
            return
        }
        self.locationManager.startMonitoring(for: AppBeacon.beaconRegion)
        realmHelper.log(beaconCentralManager: .startMonitoring)
    }
    
    /// モニタリング停止
    func stopMonitoring() {
        UserDefaultsUtil.monitoring = false
        if !self.isMonitoring() {
            // 既に監視停止済の場合は以降の処理を実施しない
            return
        }
        self.locationManager.stopMonitoring(for: AppBeacon.beaconRegion)
        realmHelper.log(beaconCentralManager: .stopMonitoring)
    }
    
    func isMonitoring() -> Bool {
        for region in self.locationManager.monitoredRegions {
            if region.identifier == AppBeacon.identifier {
                return true
            }
        }
        return false
    }
    
}
/// BeaconCentralManagerDelegate
protocol BeaconCentralManagerDelegate: class {
    func requestLocationAlways()
}
/// BeaconCentralManager+CLLocationManagerDelegate
extension BeaconCentralManager: CLLocationManagerDelegate {
    
    @available(iOS 7.0, *)
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        guard let region = region as? CLBeaconRegion else {
            return
        }
        switch state {
        case .inside:
            log.debug("didDetermineState inside " + region.identifier)
            realmHelper.log(beaconCentralManager: .didDetermineStateInside, notes: region.identifier)
            self.locationManager.startRangingBeacons(in: region)
        case .outside:
            log.debug("didDetermineState outside " + region.identifier)
            realmHelper.log(beaconCentralManager: .didDetermineStateOutside, notes: region.identifier)
            self.locationManager.stopRangingBeacons(in: region)
        default:
            break
        }
        
        // リージョン内Beacon数をリセット
        UserDefaultsUtil.countOfBeaconInRegion = 0
    }
    
    @available(iOS 4.0, *)
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        log.debug("didEnterRegion " + region.identifier)
        realmHelper.log(beaconCentralManager: .didEnterRegion, notes: region.identifier)
        NotificationFactory.enterRegion.notify()
    }
    
    @available(iOS 4.0, *)
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        log.debug("didExitRegion " + region.identifier)
        realmHelper.log(beaconCentralManager: .didExitRegion, notes: region.identifier)
        NotificationFactory.exitRegion.notify()
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        log.debug("didRangeBeacons count:=" + beacons.count.description)
        if region.identifier == AppBeacon.identifier {
            if UserDefaultsUtil.countOfBeaconInRegion != beacons.count {
                realmHelper.log(beaconCentralManager: .didRangeBeacons,
                                notes: "beacons:=" + beacons.count.description)
                UserDefaultsUtil.countOfBeaconInRegion = beacons.count
            }
            
        }
    }

}


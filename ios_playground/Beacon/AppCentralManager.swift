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
    
    
    /*
     *  locationManager:didUpdateLocations:
     *
     *  Discussion:
     *    Invoked when new locations are available.  Required for delivery of
     *    deferred locations.  If implemented, updates will
     *    not be delivered to locationManager:didUpdateToLocation:fromLocation:
     *
     *    locations is an array of CLLocation objects in chronological order.
     */
    @available(iOS 6.0, *)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        log.debug("didUpdateLocations")
    }
    
    
    /*
     *  locationManager:didUpdateHeading:
     *
     *  Discussion:
     *    Invoked when a new heading is available.
     */
    @available(iOS 3.0, *)
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        log.debug("didUpdateHeading")
    }
    
    
    /*
     *  locationManagerShouldDisplayHeadingCalibration:
     *
     *  Discussion:
     *    Invoked when a new heading is available. Return YES to display heading calibration info. The display
     *    will remain until heading is calibrated, unless dismissed early via dismissHeadingCalibrationDisplay.
     */
    @available(iOS 3.0, *)
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    
    /*
     *  locationManager:didDetermineState:forRegion:
     *
     *  Discussion:
     *    Invoked when there's a state transition for a monitored region or in response to a request for state via a
     *    a call to requestStateForRegion:.
     */
    @available(iOS 7.0, *)
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        log.debug("didDetermineState state:=" + state.description)
        guard let region = region as? CLBeaconRegion else {
            return
        }
        switch state {
        case .inside:
            self.locationManager.startRangingBeacons(in: region)
        case .outside:
            self.locationManager.stopRangingBeacons(in: region)
        default:
            break
        }
    }
    
    /*
     *  locationManager:didRangeBeacons:inRegion:
     *
     *  Discussion:
     *    Invoked when a new set of beacons are available in the specified region.
     *    beacons is an array of CLBeacon objects.
     *    If beacons is empty, it may be assumed no beacons that match the specified region are nearby.
     *    Similarly if a specific beacon no longer appears in beacons, it may be assumed the beacon is no longer received
     *    by the device.
     */
    @available(iOS 7.0, *)
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        log.debug("didRangeBeacons uuid:=" + region.proximityUUID.uuidString)
    }
    
    
    /*
     *  locationManager:rangingBeaconsDidFailForRegion:withError:
     *
     *  Discussion:
     *    Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
     */
    @available(iOS 7.0, *)
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        log.debug("rangingBeaconsDidFailFor")
    }
    
    
    /*
     *  locationManager:didEnterRegion:
     *
     *  Discussion:
     *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
     *    CLLocationManager instance with a non-nil delegate that implements this method.
     */
    @available(iOS 4.0, *)
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        log.debug("didEnterRegion")
    }
    
    
    /*
     *  locationManager:didExitRegion:
     *
     *  Discussion:
     *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
     *    CLLocationManager instance with a non-nil delegate that implements this method.
     */
    @available(iOS 4.0, *)
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        log.debug("didExitRegion")
    }
    
    
    /*
     *  locationManager:didFailWithError:
     *
     *  Discussion:
     *    Invoked when an error has occurred. Error types are defined in "CLError.h".
     */
    @available(iOS 2.0, *)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.debug("didFailWithError")
    }
    
    
    /*
     *  locationManager:monitoringDidFailForRegion:withError:
     *
     *  Discussion:
     *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
     */
    @available(iOS 4.0, *)
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        log.debug("monitoringDidFailFor")
    }
    
    
    /*
     *  locationManager:didChangeAuthorizationStatus:
     *
     *  Discussion:
     *    Invoked when the authorization status changes for this application.
     */
    @available(iOS 4.2, *)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        log.debug("didChangeAuthorization")
    }
    
    
    /*
     *  locationManager:didStartMonitoringForRegion:
     *
     *  Discussion:
     *    Invoked when a monitoring for a region started successfully.
     */
    @available(iOS 5.0, *)
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        log.debug("didStartMonitoringFor")
    }
    
    
    /*
     *  Discussion:
     *    Invoked when location updates are automatically paused.
     */
    @available(iOS 6.0, *)
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        log.debug("locationManagerDidPauseLocationUpdates")
    }
    
    
    /*
     *  Discussion:
     *    Invoked when location updates are automatically resumed.
     *
     *    In the event that your application is terminated while suspended, you will
     *	  not receive this notification.
     */
    @available(iOS 6.0, *)
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        log.debug("locationManagerDidResumeLocationUpdates")
    }
    
    
    /*
     *  locationManager:didFinishDeferredUpdatesWithError:
     *
     *  Discussion:
     *    Invoked when deferred updates will no longer be delivered. Stopping
     *    location, disallowing deferred updates, and meeting a specified criterion
     *    are all possible reasons for finishing deferred updates.
     *
     *    An error will be returned if deferred updates end before the specified
     *    criteria are met (see CLError), otherwise error will be nil.
     */
    @available(iOS 6.0, *)
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        log.debug("didFinishDeferredUpdatesWithError")
    }
    
    
    /*
     *  locationManager:didVisit:
     *
     *  Discussion:
     *    Invoked when the CLLocationManager determines that the device has visited
     *    a location, if visit monitoring is currently started (possibly from a
     *    prior launch).
     */
    @available(iOS 8.0, *)
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        log.debug("didVisit")
    }

}


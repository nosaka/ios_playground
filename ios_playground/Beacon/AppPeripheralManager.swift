//
//  AppPeripheralManager.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/19.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation


class AppPeripheralManager: NSObject {
    
    class AppBeacon {
        
        static let proximityUUID: UUID          = UUID(uuidString: "36E54BC0-AA81-4D4B-A3C9-B0FF983D24E2")!
        static let identifier: String           = "ns.me.region"
        static let localName: String            = "NSサンプルBeacon"
        static let major: CLBeaconMajorValue    = 0
        static let minor: CLBeaconMinorValue    = 0
        static var beaconRegion: CLBeaconRegion {
            return CLBeaconRegion(proximityUUID: self.proximityUUID, major: self.major, minor: self.minor, identifier: self.identifier)
        }
        static var advertisingData:[String : Any]? {
            let peripheralData = self.beaconRegion.peripheralData(withMeasuredPower: nil)
            peripheralData.setValue(self.localName, forKey: CBAdvertisementDataLocalNameKey)
            return NSDictionary(dictionary: peripheralData) as? [String : Any]
        }
    }
    
    static let `default` = AppPeripheralManager()
    
    var delegate: AppPeripheralManagerDelegate?
    
    var peripheralManager = CBPeripheralManager()
    
    /// init
    override init() {
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    /// アドバタイズ開始
    func startAdvertising() {
        UserDefaultsUtil.startAdvertising = true
        self.peripheralManager.startAdvertising(AppBeacon.advertisingData)
        
    }
    
    /// アドバタイズ停止
    func stopAdvertising() {
        UserDefaultsUtil.startAdvertising = false
        self.peripheralManager.stopAdvertising()
    }
}
/// AppPeripheralManagerDelegate
protocol AppPeripheralManagerDelegate: class {
    func requestBlePoweredOn()
}
/// AppPeripheralManager+CBPeripheralManagerDelegate
extension AppPeripheralManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        guard UserDefaultsUtil.startAdvertising else {
            return
        }
        self.peripheralManager.startAdvertising(AppBeacon.advertisingData)
        switch peripheral.state {
        case .poweredOn:
            self.peripheralManager.startAdvertising(AppBeacon.advertisingData)
        case .poweredOff:
            self.peripheralManager.stopAdvertising()
        default:
            break
        }
    }
}





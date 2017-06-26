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
        CBPeripheralManager.authorizationStatus()
        UserDefaultsUtil.advertising = true
        self.peripheralManager.startAdvertising(AppBeacon.advertisingData)
        
    }
    
    /// アドバタイズ停止
    func stopAdvertising() {
        UserDefaultsUtil.advertising = false
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
        guard UserDefaultsUtil.advertising else {
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





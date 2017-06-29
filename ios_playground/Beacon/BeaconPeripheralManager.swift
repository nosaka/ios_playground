//
//  BeaconPeripheralManager.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/19.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation


class BeaconPeripheralManager: NSObject {
    
    static let `default` = BeaconPeripheralManager()
    
    var delegate: BeaconPeripheralManagerDelegate?
    
    var peripheralManager = CBPeripheralManager()
    
    /// init
    override init() {
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    /// アドバタイズ開始
    func startAdvertising() {
        self.peripheralManager.startAdvertising(AppBeacon.advertisingData)
        
    }
    
    /// アドバタイズ停止
    func stopAdvertising() {
        self.peripheralManager.stopAdvertising()
    }
    
    /// アドバタイズ是非
    func isAdvertising() -> Bool {
        return self.peripheralManager.isAdvertising
    }
}
/// BeaconPeripheralManagerDelegate
protocol BeaconPeripheralManagerDelegate: class {
    func didUpdateBleState(peripheral: CBPeripheralManager)
}
/// AppPeripheralManager+CBPeripheralManagerDelegate
extension BeaconPeripheralManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            self.peripheralManager.startAdvertising(AppBeacon.advertisingData)
        case .poweredOff:
            self.peripheralManager.stopAdvertising()
        default:
            break
        }
        self.delegate?.didUpdateBleState(peripheral: peripheral)
    }
}





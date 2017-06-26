//
//  AppBeacon.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/22.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

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

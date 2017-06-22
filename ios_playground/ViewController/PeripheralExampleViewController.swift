//
//  PeripheralExampleViewController.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/19.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class PeripheralExampleViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var advertisingSwitch: UISegmentedControl!
    
    // MARK: statics
    
    private enum AdvertisingSwitchIndex:Int {
        case on     = 0
        case off    = 1
    }
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaultsUtil.startAdvertising {
            self.advertisingSwitch.selectedSegmentIndex = AdvertisingSwitchIndex.on.rawValue
        } else {
            self.advertisingSwitch.selectedSegmentIndex = AdvertisingSwitchIndex.off.rawValue
        }
        self.advertisingSwitch.addTarget(self, action: #selector(self.changedAdvertisingSwitch(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppPeripheralManager.default.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppPeripheralManager.default.delegate = nil
    }
    
    // MARK: selector
    
    func changedAdvertisingSwitch(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == AdvertisingSwitchIndex.on.rawValue {
            AppPeripheralManager.default.startAdvertising()
        } else {
            AppPeripheralManager.default.stopAdvertising()
        }
    }
}

extension PeripheralExampleViewController: AppPeripheralManagerDelegate {
    
    func requestBlePoweredOn() {
        self.present(AlertFactory.requestBlePoweredOn(okHandler: nil).alert, animated: true, completion: nil)
        AppPeripheralManager.default.stopAdvertising()
    }
}

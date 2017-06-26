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
import Rswift

class PeripheralExampleViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var advertisingSwitch: UISwitch!
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = R.string.localizable.peripheralExaple_title()
        
        self.advertisingSwitch.isOn = UserDefaultsUtil.advertising
        if self.advertisingSwitch.isOn {
            AppPeripheralManager.default.startAdvertising()
        } else {
            AppPeripheralManager.default.stopAdvertising()
        }
        
        self.advertisingSwitch.addTarget(self, action: #selector(self.changedAdvertisingSwitch(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppPeripheralManager.default.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AppPeripheralManager.default.delegate = nil
        super.viewDidDisappear(animated)
    }
    
    // MARK: selector
    
    func changedAdvertisingSwitch(_ sender: UISwitch) {
        if sender.isOn {
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

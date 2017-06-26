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
    
    // Notting
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = R.string.localizable.peripheralExaple_title()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppPeripheralManager.default.startAdvertising()
        AppPeripheralManager.default.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AppPeripheralManager.default.delegate = nil
        AppPeripheralManager.default.stopAdvertising()
        super.viewDidDisappear(animated)
    }

}

extension PeripheralExampleViewController: AppPeripheralManagerDelegate {
    
    func didUpdateBleState(peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            AppPeripheralManager.default.startAdvertising()
        case .poweredOff:
            self.present(AlertFactory.requestBlePoweredOn(okHandler: nil).alert, animated: true, completion: nil)
            AppPeripheralManager.default.stopAdvertising()
        default:
            AppPeripheralManager.default.stopAdvertising()
        }
    }
}

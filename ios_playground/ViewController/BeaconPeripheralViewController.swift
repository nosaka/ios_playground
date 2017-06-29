//
//  BeaconPeripheralViewController.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/19.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation
import Rswift

/// BeaconPeripheralViewController
class BeaconPeripheralViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var peripheralStateImageView: UIImageView!
    
    @IBOutlet weak var peripheralStateLabel: UILabel!
    
    // MARK: statics
    
    // MARK: variables
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = R.string.localizable.peripheralExaple_title()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground(sender:)),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        BeaconPeripheralManager.default.startAdvertising()
        BeaconPeripheralManager.default.delegate = self
        
        self.setLayoutStartAdvertising()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)

        BeaconPeripheralManager.default.delegate = nil
        BeaconPeripheralManager.default.stopAdvertising()
        super.viewDidDisappear(animated)
    }
    
    func willEnterForeground(sender: Any) {
        if BeaconPeripheralManager.default.isAdvertising() {
            self.setLayoutStartAdvertising()
        } else {
            self.setLayoutStopAdvertising()
        }
    }
    
    /// アドバタイズ開始時レイアウト設定処理
    func setLayoutStartAdvertising() {
        self.peripheralStateLabel.text = R.string.localizable.peripheralExaple_startAdvertising()
        if !self.peripheralStateImageView.isAnimating {
            self.peripheralStateImageView.image = R.image.peripheral_On()
            UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: .repeat, animations: {
                self.peripheralStateImageView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            }) { _ in
                self.peripheralStateImageView.transform = CGAffineTransform.identity
            }
        }
    }
    
    /// アドバタイズ停止時レイアウト設定処理
    func setLayoutStopAdvertising() {
        self.peripheralStateLabel.text = R.string.localizable.peripheralExaple_stopAdvertising()
        
        self.peripheralStateImageView.layer.removeAllAnimations()
        self.peripheralStateImageView.image = R.image.peripheral_Off()
    }
    
    /// アドバタイズエラー時レイアウト設定処理
    func setLayoutErrorAdvertising() {
        self.peripheralStateLabel.text = R.string.localizable.peripheralExaple_errorAdvertising()
        
        self.peripheralStateImageView.layer.removeAllAnimations()
        self.peripheralStateImageView.image = R.image.peripheral_Off()
    }

}
/// BeaconPeripheralViewController+BeaconPeripheralManagerDelegate
extension BeaconPeripheralViewController: BeaconPeripheralManagerDelegate {
    
    func didUpdateBleState(peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            BeaconPeripheralManager.default.startAdvertising()
            self.setLayoutStartAdvertising()
        case .poweredOff:
            self.present(AlertFactory.requestBlePoweredOn(okHandler: nil).alert, animated: true, completion: nil)
            BeaconPeripheralManager.default.stopAdvertising()
            self.setLayoutStopAdvertising()
        default:
            BeaconPeripheralManager.default.stopAdvertising()
            self.setLayoutErrorAdvertising()
        }
    }
}

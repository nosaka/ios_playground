//
//  CentralExampleViewController.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/22.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import UIKit

class CentralExampleViewController: UIViewController {

    // MARK: IBOutlet
    
    @IBOutlet weak var monitoringSwitch: UISwitch!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = R.string.localizable.centralExaple_title()

        if UserDefaultsUtil.monitoring {
            AppCentralManager.default.startMonitoring()
        } else {
            AppCentralManager.default.stopMonitoring()
        }
        self.monitoringSwitch.isOn = UserDefaultsUtil.monitoring
        
        self.monitoringSwitch.addTarget(self, action: #selector(self.changedMonitoringSwitch(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppCentralManager.default.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AppCentralManager.default.delegate = nil
        super.viewDidDisappear(animated)
    }
    
    // MARK: selector
    
    func changedMonitoringSwitch(_ sender: UISwitch) {
        if sender.isOn {
            AppCentralManager.default.startMonitoring()
        } else {
            AppCentralManager.default.stopMonitoring()
        }
    }
}

extension CentralExampleViewController: AppCentralManagerDelegate {
    
    func requestLocationAlways() {
        // モニタリング開始処理が失敗した場合はスイッチを戻した後、ダイアログを表示する
        self.monitoringSwitch.setOn(false, animated: true)
        self.present(AlertFactory.requestLocationAlways.alert, animated: true, completion: nil)
        AppCentralManager.default.stopMonitoring()
    }
}


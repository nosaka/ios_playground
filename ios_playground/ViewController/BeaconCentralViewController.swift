//
//  BeaconCentralViewController.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/22.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import UIKit
import RealmSwift

/// BeaconCentralViewController
class BeaconCentralViewController: UIViewController {

    // MARK: IBOutlet
    
    @IBOutlet weak var monitoringSwitch: UISwitch!
    
    @IBOutlet weak var centralManagerLogTableView: UITableView!
    
    // MARK: statics
    
    // MARK: variables
    
    fileprivate var tableData: Results<BeaconCentralManagerLog>?
    
    fileprivate var tokenCentralManagerLog: NotificationToken?

    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Viewの設定
        self.title = R.string.localizable.centralExaple_title()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.tappedTrashBarButtonItem(_:)))

        if UserDefaultsUtil.monitoring {
            BeaconCentralManager.default.startMonitoring()
        } else {
            BeaconCentralManager.default.stopMonitoring()
        }
        self.monitoringSwitch.isOn = UserDefaultsUtil.monitoring
        
        self.centralManagerLogTableView.register(R.nib.centralManagerLogCell(), forCellReuseIdentifier: CentralManagerLogCell.cellIdentifier)
        
        
        // Selector、Delegateの設定
        self.monitoringSwitch.addTarget(self, action: #selector(self.changedMonitoringSwitch(_:)), for: .valueChanged)
        self.centralManagerLogTableView.delegate = self
        self.centralManagerLogTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BeaconCentralManager.default.delegate = self
        
        self.tableData = realmHelper.all(BeaconCentralManagerLog.self, sorted: (BeaconCentralManagerLog.defaultSortKey, false))
        self.tokenCentralManagerLog =
            self.tableData?.addNotificationBlock { result in
                switch result {
                case .initial:
                    self.centralManagerLogTableView.reloadData()
                case .update:
                    self.centralManagerLogTableView.reloadData()
                case .error(let error):
                    log.error(error.localizedDescription)
                }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        BeaconCentralManager.default.delegate = nil
        self.tokenCentralManagerLog?.stop()
        super.viewDidDisappear(animated)
    }
    
    // MARK: selector
    
    func changedMonitoringSwitch(_ sender: UISwitch) {
        if sender.isOn {
            BeaconCentralManager.default.startMonitoring()
        } else {
            BeaconCentralManager.default.stopMonitoring()
        }
    }
    
    func tappedTrashBarButtonItem(_ sender: UIBarButtonItem) {
        realmHelper.delete(BeaconCentralManagerLog.self)
        self.centralManagerLogTableView.reloadData()
    }
    
}
/// BeaconCentralViewController+BeaconCentralManagerDelegate
extension BeaconCentralViewController: BeaconCentralManagerDelegate {
    
    func requestLocationAlways() {
        // モニタリング開始処理が失敗した場合はスイッチを戻した後、ダイアログを表示する
        self.monitoringSwitch.setOn(false, animated: true)
        self.present(AlertFactory.requestLocationAlways.alert, animated: true, completion: nil)
        BeaconCentralManager.default.stopMonitoring()
    }
}
/// BeaconCentralViewController+UITableViewDelegate
extension BeaconCentralViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CentralManagerLogCell.height
    }
    
}
/// BeaconCentralViewController+UITableViewDataSource
extension BeaconCentralViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CentralManagerLogCell.cellIdentifier, for:indexPath) as! CentralManagerLogCell
        
        guard let item = self.tableData?[indexPath.row] else {
            return cell
        }
        
        if let time = item.time {
            cell.dateLabel.text = AppDateFormatter.iso8601.string(from: time)
        } else {
            cell.dateLabel.text = R.string.localizable.unknown()
        }
        
        cell.messageLabel.text = item.logType.localizable
        return cell
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.tableData?.count ?? 0
    }
}


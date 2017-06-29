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
    
    @IBOutlet weak var beaconCentralManagerLogTableView: UITableView!
    
    // MARK: statics
    
    // MARK: variables
    
    fileprivate var tableData: Results<BeaconCentralManagerLog>?
    
    fileprivate var tokenTableDataResults: NotificationToken?

    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Viewの設定
        self.title = R.string.localizable.beaconCentral_title()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.tappedTrashBarButtonItem(_:)))

        if UserDefaultsUtil.monitoring {
            BeaconCentralManager.default.startMonitoring()
        } else {
            BeaconCentralManager.default.stopMonitoring()
        }
        self.monitoringSwitch.isOn = UserDefaultsUtil.monitoring
        
        self.beaconCentralManagerLogTableView.register(R.nib.logCell(), forCellReuseIdentifier: LogCell.cellIdentifier)
        
        
        // Selector、Delegateの設定
        self.monitoringSwitch.addTarget(self, action: #selector(self.changedMonitoringSwitch(_:)), for: .valueChanged)
        self.beaconCentralManagerLogTableView.delegate = self
        self.beaconCentralManagerLogTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BeaconCentralManager.default.delegate = self
        
        self.tableData = realmHelper.all(BeaconCentralManagerLog.self, sorted: (BeaconCentralManagerLog.defaultSortKey, false))
        self.tokenTableDataResults =
            self.tableData?.addNotificationBlock { result in
                switch result {
                case .initial:
                    self.beaconCentralManagerLogTableView.reloadData()
                case .update:
                    self.beaconCentralManagerLogTableView.reloadData()
                case .error(let error):
                    log.error(error.localizedDescription)
                }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        BeaconCentralManager.default.delegate = nil
        self.tokenTableDataResults?.stop()
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
        self.beaconCentralManagerLogTableView.reloadData()
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
        return LogCell.height
    }
    
}
/// BeaconCentralViewController+UITableViewDataSource
extension BeaconCentralViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogCell.cellIdentifier, for:indexPath) as! LogCell
        
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

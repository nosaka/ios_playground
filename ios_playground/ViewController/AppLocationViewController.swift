//
//  AppLocationViewController.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/29.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import UIKit
import RealmSwift

class AppLocationViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var updateLocationSwitch: UISwitch!
    
    @IBOutlet weak var appLocationManagerLogTableView: UITableView!
    
    // MARK: statics
    
    // MARK: variables
    
    fileprivate var tableData: Results<AppLocationManagerLog>?
    
    fileprivate var tokenTableDataResults: NotificationToken?
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        // Viewの設定
        self.title = R.string.localizable.centralExaple_title()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.tappedTrashBarButtonItem(_:)))
        
        if UserDefaultsUtil.updateLocation {
            AppLocationManager.default.startUpdateLocation()
        } else {
            AppLocationManager.default.stopUpdateLocation()
        }
        self.updateLocationSwitch.isOn = UserDefaultsUtil.updateLocation
        
        self.appLocationManagerLogTableView.register(R.nib.logCell(), forCellReuseIdentifier: LogCell.cellIdentifier)
        
        
        // Selector、Delegateの設定
        self.updateLocationSwitch.addTarget(self, action: #selector(self.changedUpdateLocationSwitch(_:)), for: .valueChanged)
        self.appLocationManagerLogTableView.delegate = self
        self.appLocationManagerLogTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppLocationManager.default.delegate = self
        
        self.tableData = realmHelper.all(AppLocationManagerLog.self, sorted: (AppLocationManagerLog.defaultSortKey, false))
        self.tokenTableDataResults =
            self.tableData?.addNotificationBlock { result in
                switch result {
                case .initial:
                    self.appLocationManagerLogTableView.reloadData()
                case .update:
                    self.appLocationManagerLogTableView.reloadData()
                case .error(let error):
                    log.error(error.localizedDescription)
                }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AppLocationManager.default.delegate = nil
        self.tokenTableDataResults?.stop()
        super.viewDidDisappear(animated)
    }
    
    // MARK: selector
    
    func changedUpdateLocationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            AppLocationManager.default.startUpdateLocation()
        } else {
            AppLocationManager.default.stopUpdateLocation()
        }
    }
    
    func tappedTrashBarButtonItem(_ sender: UIBarButtonItem) {
        realmHelper.delete(AppLocationManagerLog.self)
        self.appLocationManagerLogTableView.reloadData()
    }

}
/// AppLocationViewController+AppLocationManagerDelegate
extension AppLocationViewController: AppLocationManagerDelegate {
    
    func requestLocationAlways() {
        // モニタリング開始処理が失敗した場合はスイッチを戻した後、ダイアログを表示する
        self.updateLocationSwitch.setOn(false, animated: true)
        self.present(AlertFactory.requestLocationAlways.alert, animated: true, completion: nil)
        AppLocationManager.default.stopUpdateLocation()
    }
}
/// AppLocationViewController+UITableViewDelegate
extension AppLocationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LogCell.height
    }
    
}
/// AppLocationViewController+UITableViewDataSource
extension AppLocationViewController: UITableViewDataSource {
    
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

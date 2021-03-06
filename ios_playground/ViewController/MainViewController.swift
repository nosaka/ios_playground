//
//  MainViewController.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/19.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var menuTableView: UITableView!
    
    // MARK: statics
    
    let cellIdentifier = "default"
    
    enum TableViewItem {
        case bluetoothPeripheral
        case bluetoothCentral
        case locationUpdate
        
        static let items:[TableViewItem] = [.bluetoothPeripheral,
                                            .bluetoothCentral,
                                            .locationUpdate]
        
        var text: String {
            get {
                switch self {
                case .bluetoothPeripheral:
                    return R.string.localizable.main_list_item_bluetoothPeripheral()
                case .bluetoothCentral:
                    return R.string.localizable.main_list_item_bluetoothCentral()
                case .locationUpdate:
                    return R.string.localizable.main_list_item_locationUpdate()
                }
            }
        }

    }
    
    // MARK: variables
    
    var tableData: [TableViewItem] = TableViewItem.items
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Viewの設定
        self.edgesForExtendedLayout = []
        
        // Selector、Delegateの設定
        self.menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
    }
    
}
/// MainViewController+UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.tableData[indexPath.row]
        switch item {
        case .bluetoothCentral:
            self.navigationController?.pushViewController(BeaconCentralViewController(), animated: true)
        case .bluetoothPeripheral:
            self.navigationController?.pushViewController(BeaconPeripheralViewController(), animated: true)
        case .locationUpdate:
            self.navigationController?.pushViewController(AppLocationViewController(), animated: true)
        }
    }
}
/// MainViewController+UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for:indexPath)
        
        cell.textLabel?.text = self.tableData[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.tableData.count
    }
}




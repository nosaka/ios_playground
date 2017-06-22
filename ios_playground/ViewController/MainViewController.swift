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
        
        static let items:[TableViewItem] = [.bluetoothPeripheral, .bluetoothCentral]
        
        var text: String {
            get {
                switch self {
                case .bluetoothPeripheral:
                    return R.string.localizable.main_list_item_bluetoothPeripheral()
                case .bluetoothCentral:
                    return R.string.localizable.main_list_item_bluetoothCentral()
                }
            }
        }

    }
    
    // MARK: variables
    
    var tableData:[TableViewItem] = TableViewItem.items
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        self.menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
    }
    
}
/// MainViewController+UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(PeripheralExampleViewController(), animated: true)
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




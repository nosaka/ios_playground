//
//  AlertFactory.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/19.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import UIKit
import Rswift

enum AlertFactory {
    
    case requestBlePoweredOn(okHandler: ((UIAlertAction) -> Swift.Void)?)
    case requestLocationAlways
    
    var alert: UIAlertController {
        switch self {
            
        case .requestBlePoweredOn(let okHandler):
            let alert = UIAlertController(title: R.string.localizable.alert_ttl_requestBlePoweredOn(),
                                          message: R.string.localizable.alert_msg_requestBlePoweredOn(),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.alert_action_ok(), style: .default, handler: okHandler))
            return alert
        case .requestLocationAlways:
            let alert = UIAlertController(title: R.string.localizable.alert_ttl_requestLocationAlways(),
                                          message: R.string.localizable.alert_msg_requestLocationAlways(),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.alert_action_open_setting(), style: .default, handler: { action in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }

            }))
            alert.addAction(UIAlertAction(title: R.string.localizable.alert_action_cancel(), style: .cancel, handler: nil))
            return alert
        }
    }
  
}

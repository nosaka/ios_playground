//
//  AlertFactory.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/19.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import UIKit

enum AlertFactory {
    
    case requestBlePoweredOn(okHandler: ((UIAlertAction) -> Swift.Void)?)
    
    var alert: UIAlertController {
        switch self {
        case .requestBlePoweredOn(let okHandler):
            let alert = UIAlertController(title: localized(resource: "alert_ttl_requestBlePoweredOn"),
                                          message: localized(resource: "alert_msg_requestBlePoweredOn"),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: localized(resource: "alert_action_ok"), style: .default, handler: okHandler))
            return alert
        }
    }
    
    
    func localized(resource: String) -> String {
        return NSLocalizedString("alert_ttl_requestBlePoweredOn", comment: "")
    }
  
}

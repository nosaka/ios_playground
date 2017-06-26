//
//  NotificationFactory.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/26.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation
import UIKit

enum NotificationFactory {
    case logging(NotificationLogging) // Debug用
    case enterRegion
    case exitRegion
    
    func notify(interval: TimeInterval = 0) {
        let notification = self.generateNotification(interval: interval)
        switch self {
        case .logging(let logging):
            notification.alertTitle = logging.content.title
            notification.alertBody = logging.content.body
        case .enterRegion:
            notification.alertBody = "enterRegion"
        case .exitRegion:
            notification.alertBody = "exitRegion"
        }
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    /// 通知オブジェクト生成処理
    private func generateNotification(interval: TimeInterval) -> UILocalNotification {
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: interval)
        notification.timeZone = NSTimeZone.default
        
        return notification
    }

}

typealias NotificationLoggingContent = (title: String?, body: String?)

enum NotificationLogging {
    case monitoredRegionWhenLaunch(CLLocationManager)
    
    public var content: NotificationLoggingContent {
        get {
            switch self {
            case .monitoredRegionWhenLaunch(let manager):
                return NotificationLoggingContent(title: "application launch by location",
                                                  body: String(format: "%d monitoring.",
                                                               manager.monitoredRegions.count))
            }
        }
    }
}

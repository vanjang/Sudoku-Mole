//
//  NotificationCentre.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/28.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UserNotifications

struct UserNotificationCentre {
    static let notificationCentre = UNUserNotificationCenter.current()
    
    static func notificationSetup() {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = "Smole says: How was your lunch?".localized()
        content.body = "What about having a cup of coffee and playing a Sudoku Mole? Let's break your record!".localized()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 13, minute: 30, weekday: 3, weekOfMonth: 1), repeats: true)
        let identifier = "localNotification"
        
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 13, minute: 30, weekday: 3, weekOfMonth: 3), repeats: true)
        let identifier2 = "localNotification2"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        let request2 = UNNotificationRequest(identifier: identifier2, content: content, trigger: trigger2)
        
        notificationCentre.add(request) { (error) in
            if let _ = error {
            }
        }
        
        notificationCentre.add(request2) { (error) in
            if let _ = error {
            }
        }
    }
    
}

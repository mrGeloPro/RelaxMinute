//
//  SystemNotificationService.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//

import Foundation
import UserNotifications

final class SystemNotificationService: NotificationServiceProtocol {
    
    func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        
        let isAuthorized: Bool = await withCheckedContinuation { continuation in
            center.getNotificationSettings { settings in
                continuation.resume(returning: settings.authorizationStatus == .authorized)
            }
        }
        
        if isAuthorized { return true }
        
        return await withCheckedContinuation { continuation in
            center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
                continuation.resume(returning: granted)
            }
        }
    }
    
    func scheduleNotification(timeInterval: TimeInterval) {
        cancelNotifications()
        let content = UNMutableNotificationContent()
        content.title = "Break is over!"
        content.body = "Great job! You took a minute to relax."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: "timer_completed", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

//
//  NotificationServiceProtocol.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//

import Foundation

protocol NotificationServiceProtocol {
    func requestAuthorization() async -> Bool
    func scheduleNotification(timeInterval: TimeInterval)
    func cancelNotifications()
}

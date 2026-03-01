//
//  MockNotificationService.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 01.03.2026.
//


import Foundation
@testable import RelaxMinute

final class MockNotificationService: NotificationServiceProtocol {
    var isAuthorized = true
    var didScheduleNotification = false
    var didCancelNotifications = false
    
    func requestAuthorization() async -> Bool {
        return isAuthorized
    }
    
    func scheduleNotification(timeInterval: TimeInterval) {
        didScheduleNotification = true
    }
    
    func cancelNotifications() {
        didCancelNotifications = true
    }
}

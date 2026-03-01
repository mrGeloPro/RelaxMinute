//
//  Alert+Data.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//

extension AlertType {
    
    var title: String {
        switch self {
        case .notificationsDisabled:
            "Notifications Disabled"
        case .stopConfirmation:
            "Stop Timer?"
        case .unowned:
            "Unknown Alert"
        }
    }
    
    var message: String {
        switch self {
        case .notificationsDisabled:
            "To receive an alert when the timer finishes in the background, please enable notifications in Settings."
        case .stopConfirmation:
            "Are you sure you want to stop the timer? Your progress will be lost."
        case .unowned:
            "An unexpected error occurred."
        }
    }
    
    var primaryButtonTitle: String {
        switch self {
        case .notificationsDisabled:
            "Open Settings"
        case .stopConfirmation:
            "Stop"
        case .unowned:
            "OK"
        }
    }
    
    var secondaryButtonTitle: String? {
        switch self {
        case .notificationsDisabled:
            "Close"
        case .stopConfirmation:
            "Continue"
        case .unowned:
            nil
        }
    }
}

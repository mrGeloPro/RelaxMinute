//
//  AlertType.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//
import Foundation

@MainActor
enum AlertType: @MainActor Identifiable, Hashable {
    var id: String {
        rawValue
    }
    
    var rawValue: String {
        switch self {
        case .notificationsDisabled:
            "notificationsDisabled"
        case .stopConfirmation:
            "stopConfirmation"
        case .unowned:
            "unowned"
        }
    }
    
    case notificationsDisabled
    case stopConfirmation
    case unowned
}

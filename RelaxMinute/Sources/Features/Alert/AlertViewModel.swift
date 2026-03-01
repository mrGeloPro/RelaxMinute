//
//  AlertViewModel.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//
import Combine
import SwiftUI

@MainActor
final class AlertViewModel: ObservableObject {
    @Published var title: String = "Title"
    @Published var message: String = "Message"
    @Published var alertActions: [any AlertAction] = []
    
    var onPresentSettings: (() -> Void)?
    var onStopTimer: (() -> Void)?
    var onDismissCurrentAlert: (() -> Void)?
    
    init(type: AlertType) {
        self.title = type.title
        self.message = type.message
        self.buildAction(type:type)
    }
    
    private func buildAction(type: AlertType) {
        alertActions.append(AlertActionModel(title: type.primaryButtonTitle, style: .primary, handler: {
            self.handlerPrimaryAction(for: type)
        }))
        
        if let title = type.secondaryButtonTitle {
            alertActions.append(AlertActionModel(title: title,style: .secondary, handler: {
                self.handlerSecondaryAction(for: type)
            }))
        }
    }
    
    private func handlerPrimaryAction(for type: AlertType) {
        switch type {
        case .notificationsDisabled:
            onPresentSettings?()
            onDismissCurrentAlert?()
        case .stopConfirmation:
            onStopTimer?()
            onDismissCurrentAlert?()
        case .unowned:
            onDismissCurrentAlert?()
            break
        }
    }
    
    private func handlerSecondaryAction(for type: AlertType) {
        onDismissCurrentAlert?()
    }
    
}

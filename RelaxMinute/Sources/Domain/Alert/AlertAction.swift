//
//  AlertAction.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//
import Foundation

enum AlertActionStyle {
    case primary
    case secondary
}

protocol AlertAction: Identifiable {
    var id: UUID { get }
    var title: String { get }
    var style: AlertActionStyle { get }
    var handler: () -> Void { get }
}

struct AlertActionModel: AlertAction {
    let id = UUID()
    let title: String
    let style: AlertActionStyle
    let handler: () -> Void
}

//
//  ActionButtonStyle.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//
import SwiftUI

struct TonalButtonStyle: ButtonStyle {
    var role: ButtonRole = .cancel
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor.opacity(configuration.isPressed ? 0.7 : 1.0))
            )
            .foregroundColor(foregroundColor)
            .opacity(isEnabled ? 1.0 : 0.4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
    
    private var backgroundColor: Color {
        role == .destructive ? .buttonStopBackgraund : .buttonStartBackground
    }
    
    private var foregroundColor: Color {
        role == .destructive ? .buttonStopText : .textSecondary
    }
}

struct SolidButtonStyle: ButtonStyle {
    var role: ButtonRole = .general
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor.opacity(configuration.isPressed ? 0.8 : 1.0))
            )
            .foregroundColor(foregroundColor)
            .opacity(isEnabled ? 1.0 : 0.4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
    
    private var backgroundColor: Color {
        role == .timer ? .buttonStartBackground : .accentBlue
    }
    
    private var foregroundColor: Color {
        role == .timer ? .textGreenPrimary : .white
    }
}

extension ButtonRole {
    public static let timer: ButtonRole = .timer
    public static let general: ButtonRole = .general
}

extension ButtonStyle where Self == TonalButtonStyle {
    static func tonal(role: ButtonRole = .cancel) -> TonalButtonStyle {
        TonalButtonStyle(role: role)
    }
}

extension ButtonStyle where Self == SolidButtonStyle {
    static func solidBlue(role: ButtonRole = .general) -> SolidButtonStyle {
        SolidButtonStyle(role: role)
    }
}

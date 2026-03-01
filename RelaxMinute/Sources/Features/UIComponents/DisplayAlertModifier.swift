//
//  DisplayAlertModifier.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//

import SwiftUI

struct DisplayAlertModifier: ViewModifier {
    var alertBody: AnyScreen?
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: alertBody != nil ? 2 : 0)
                .disabled(alertBody != nil)
            
            if let alert = alertBody {
                alert.view()
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .zIndex(999)
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.5), value: alertBody)
    }
}

extension View {
    func handleDisplay(alerts: Binding<[AnyScreen]>) -> some View {
        modifier(DisplayAlertModifier(alertBody: alerts.wrappedValue.last))
    }
}

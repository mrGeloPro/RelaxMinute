//
//  CustomAlertView.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//

import SwiftUI

struct CustomAlertView: View {
    @ObservedObject var viewModel: AlertViewModel
    let screenId: String = UUID().uuidString
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.onDismissCurrentAlert?()
                }
            
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(viewModel.title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                HStack(spacing: 12) {
                    ForEach (viewModel.alertActions, id: \.id) { action in
                        Button(action: action.handler) {
                            Text(action.title)
                                .lineLimit(1)
                        }
                        .applyStyle(action.style)
                    }
                }
            }
            .padding(24)
            .background(.appBackground)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal, 30)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

extension CustomAlertView: Screen {
    var id: String { screenId }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CustomAlertView, rhs: CustomAlertView) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Helper for Styling
private extension View {
    @ViewBuilder
    func applyStyle(_ style: AlertActionStyle) -> some View {
        switch style {
        case .primary:
            buttonStyle(.solidBlue())
        case .secondary:
            buttonStyle(.tonal())
        }
    }
}

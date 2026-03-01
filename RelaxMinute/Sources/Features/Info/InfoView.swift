//
//  InfoView.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//
import SwiftUI

struct InfoView: View {
    @StateObject var viewModel: InfoViewModel
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading, spacing: 32) {
                Spacer()
                Text("Why a 1-Minute Break?")
                    .font(.title)
                    .bold()
                    .foregroundColor(.textPrimary)
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        InfoRow(icon: "lungs.fill", title: "Breathe Deeply", description: "60 seconds of deep breathing lowers cortisol and reduces stress instantly.")
                        InfoRow(icon: "eye.fill", title: "Rest Your Eyes", description: "Looking away from the screen helps prevent digital eye strain.")
                        InfoRow(icon: "brain.head.profile", title: "Regain Focus", description: "A micro-break acts as a reset button for your attention span.")
                    }
                }
                
                Spacer()
                
                Button(action: { viewModel.onDismiss?()}) {
                    Text("Got it")
                }
                .buttonStyle(.solidBlue())
                .padding(.bottom, 20)
                
            }
            .padding(24)
            .background(.sheetBackground).ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {  viewModel.onDismiss?() }
                        .font(.title3).foregroundColor(.accent)
                }
            }
        }.presentationDetents([.fraction(0.70)])
    }
}

extension InfoView: Screen {
    var id: String { "InfoView" }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: InfoView, rhs: InfoView) -> Bool {
        lhs.id == rhs.id
    }
}

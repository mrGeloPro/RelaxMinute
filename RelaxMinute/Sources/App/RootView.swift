//
//  RootView.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//
import SwiftUI

struct RootView: View {
    @StateObject var router = NavigationRouter()
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            coordinator.makeMainScreen()
                .navigationDestination(for: AnyScreen.self) { screen in
                    screen.view()
                }
        }
        .onAppear {
            coordinator.setup(router: router)
        }
        .sheet(item: $router.sheet, content: { $0.view() })
        .handleDisplay(alerts: $router.alerts)
    }
}

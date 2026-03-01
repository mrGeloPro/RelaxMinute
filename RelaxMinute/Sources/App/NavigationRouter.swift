//
//  NavigationRouter.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//

import SwiftUI
import Combine

@MainActor
final class NavigationRouter: ObservableObject {
    @Published var path: NavigationPath = .init()
    @Published var alerts: [AnyScreen] = []
    @Published var sheet: AnyScreen?
    
    func push(_ r: some Hashable) {
        path.append(r)
    }
    
    func pop() { if !path.isEmpty { path.removeLast() } }
    func pop(levels: Int) { guard levels > 0, levels <= path.count else { return }
        path.removeLast(levels)
    }
    
    func popToRoot() { path.removeLast(path.count) }
    
    func setPath(_ routes: [some Hashable]) {
        var new = NavigationPath()
        for r in routes {
            new.append(r)
        }
        path = new
    }
    
    func presentNew(_ alert: some Screen) {
        alerts.append(AnyScreen(alert))
    }
    
    func dismissAlert() {
        guard !alerts.isEmpty else { return }
        alerts.removeLast()
    }
    
    func dismissAllAlerts() {
        guard !alerts.isEmpty else { return }
        alerts.removeAll()
    }
    
    func present(_ sheet: some Screen) {
        self.sheet = AnyScreen(sheet)
    }
    
    func dismissSheet() { sheet = nil }
}

protocol Screen: View, Identifiable, Hashable {}

struct AnyScreen: Identifiable, Hashable {
    let id: AnyHashable
    
    private let box: AnyHashable
    private let makeView: () -> AnyView
    
    init(_ screen: some Screen) {
        id = AnyHashable(screen.id)
        box = AnyHashable(screen)
        makeView = { AnyView(screen) }
    }
    
    func view() -> AnyView { makeView() }
    
    static func == (lhs: AnyScreen, rhs: AnyScreen) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func unwrap<S: Screen>(_: S.Type) -> S? {
        box.base as? S
    }
}

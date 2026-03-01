//
//  AppCoordinator.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//
import Combine
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    @Published private var router: NavigationRouter? = nil
    
    private let persistence = UserDefaultsTimerPersistence()
    private let notifications = SystemNotificationService()
    private let stopTimerSubject = PassthroughSubject<Void, Never>()
    lazy var timerViewModel: TimerViewModel = {
        let timerViewModel = TimerViewModel(
            persistence: persistence,
            notifications: notifications,
            stopSignal: stopTimerSubject.eraseToAnyPublisher()
        )
        self.setupTimerActions(for: timerViewModel)
        
        return timerViewModel
    }()
    
    func setup(router: NavigationRouter) {
        self.router = router
    }
    
    func makeMainScreen() -> some View {
        return TimerView(viewModel: self.timerViewModel)
    }
    
    func setupTimerActions(for viewModel: TimerViewModel) {
        viewModel.onShowInfo = { [weak self] in
            self?.showInfo()
        }
        
        viewModel.onShowStopAlert = { [weak self] in
            guard let self = self else { return }
            
            let alertViewModel = AlertViewModel(type: .stopConfirmation)
            self.setupAlertActions(for: alertViewModel)
            self.router?.presentNew(CustomAlertView(viewModel: alertViewModel))
        }
        
        viewModel.onShowNotificationAlert = { [weak self] in
            guard let self = self else { return }
            
            let alertViewModel = AlertViewModel(type: .notificationsDisabled)
            self.setupAlertActions(for: alertViewModel)
            self.router?.presentNew(CustomAlertView(viewModel: alertViewModel))
        }
    }
    
    func setupAlertActions(for viewModel: AlertViewModel) {
        viewModel.onDismissCurrentAlert = { [weak self] in
            guard let self = self else { return }
            self.router?.dismissAlert()
        }
        
        viewModel.onStopTimer = { [weak self] in
            guard let self = self else { return }
            
            self.stopTimerSubject.send(())
        }
        viewModel.onPresentSettings = { [weak self] in
            guard let self = self else { return }
            self.presentSettings()
        }
    }
    
    func showInfo() {
        let infoViewModel = InfoViewModel()
        infoViewModel.onDismiss = { [weak self] in
            self?.dismissSheet()
        }
        self.router?.present(InfoView(viewModel: infoViewModel))
    }
    
    func dismissSheet() {
        self.router?.dismissSheet()
    }
    
    func presentSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    func showAlert(type: AlertType) {
        self.router?.presentNew(CustomAlertView(viewModel: AlertViewModel(type: type)))
    }
    
    func dismissCurrentAlert() {
        self.router?.dismissAlert()
    }
    
    func stopTimer() {
        stopTimerSubject.send(())
    }
}

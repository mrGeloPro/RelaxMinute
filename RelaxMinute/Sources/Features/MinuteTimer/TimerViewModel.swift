//
//  TimerViewModel.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//

import Foundation
import Combine

enum TimerState {
    case idle, running, paused
}

@MainActor
final class TimerViewModel: ObservableObject {
    @Published private(set) var timeRemaining: TimeInterval = 60.0
    @Published private(set) var state: TimerState = .idle
    private var cancellables = Set<AnyCancellable>()
    var onShowInfo: (() -> Void)?
    var onShowStopAlert: (() -> Void)?
    var onShowNotificationAlert: (() -> Void)?
    
    var progress: Double { timeRemaining / 60.0 }
    
    var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        let milliseconds = Int((timeRemaining.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    var accessibilityTimeString: String {
        let seconds = Int(ceil(timeRemaining))
        return "\(seconds) seconds remaining"
    }
    
    private let persistence: TimerPersistenceProtocol
    private let notifications: NotificationServiceProtocol
    private var timerCancellable: AnyCancellable?
    
    init(persistence: TimerPersistenceProtocol, notifications: NotificationServiceProtocol, stopSignal: AnyPublisher<Void, Never>) {
        self.persistence = persistence
        self.notifications = notifications
        stopSignal.receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.stopTimer()
            }
            .store(in: &cancellables)
        restoreState()
    }
    
    func toggleStartPause() {
        switch state {
        case .idle, .paused:
            startTimer()
        case .running:
            pauseTimer()
        }
    }
    
    func stopTimer() {
        state = .idle
        timeRemaining = 60.0
        timerCancellable?.cancel()
        notifications.cancelNotifications()
        persistence.saveState(endDate: nil, timeRemaining: 60.0)
    }
    
    private func startTimer() {
        Task { @MainActor in
            let isAuthorized = await notifications.requestAuthorization()
            
            if !isAuthorized && state == .idle {
                onShowNotificationAlert?()
            }
            state = .running
            
            let endDate = Date().addingTimeInterval(timeRemaining)
            persistence.saveState(endDate: endDate, timeRemaining: timeRemaining)
            
            timerCancellable = Timer.publish(every: 0.01, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    self?.tick()
                }
        }
    }
    
    private func pauseTimer() {
        state = .paused
        timerCancellable?.cancel()
        notifications.cancelNotifications()
        persistence.saveState(endDate: nil, timeRemaining: timeRemaining)
    }
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 0.01
        } else {
            timeRemaining = 0
            stopTimer()
        }
    }
    
    func syncWithAppLifecycle(isActive: Bool) {
        if isActive {
            notifications.cancelNotifications()
            restoreState()
        } else {
            if state == .running {
                notifications.scheduleNotification(timeInterval: timeRemaining)
            }
            timerCancellable?.cancel()
        }
    }
    
    private func restoreState() {
        let savedState = persistence.fetchState()
        if let endDate = savedState.endDate {
            let remaining = endDate.timeIntervalSinceNow
            if remaining > 0 {
                timeRemaining = remaining
                startTimer()
            } else {
                stopTimer()
            }
        } else {
            timeRemaining = savedState.timeRemaining
            state = timeRemaining < 60.0 ? .paused : .idle
        }
    }
}

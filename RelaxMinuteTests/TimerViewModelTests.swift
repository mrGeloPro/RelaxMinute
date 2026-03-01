//
//  TimerViewModelTests.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 01.03.2026.
//

import Testing
import Combine
import Foundation
@testable import RelaxMinute

@Suite("TimerViewModel Tests")
@MainActor
final class TimerViewModelTests {
    var sut: TimerViewModel!
    var mockPersistence: MockTimerPersistence!
    var mockNotifications: MockNotificationService!
    var stopSignal: PassthroughSubject<Void, Never>!
    var cancellables: Set<AnyCancellable>!
    
    init() {
        mockPersistence = MockTimerPersistence()
        mockNotifications = MockNotificationService()
        stopSignal = PassthroughSubject<Void, Never>()
        cancellables = []
        
        sut = TimerViewModel(
            persistence: mockPersistence,
            notifications: mockNotifications,
            stopSignal: stopSignal.eraseToAnyPublisher()
        )
    }
    
    @Test("Initial state should be idle with 60 seconds")
    func initialState() {
        #expect(sut.state == .idle)
        #expect(sut.timeRemaining == 60.0)
    }
    
    @Test("Stop timer resets state and cancels notifications")
    func stopTimerResetsState() async throws {
        sut.toggleStartPause()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(sut.state == .running)
        #expect(sut.timeRemaining < 60.0)
        
        sut.stopTimer()
        
        #expect(sut.state == .idle)
        #expect(sut.timeRemaining == 60.0)
        #expect(mockNotifications.didCancelNotifications == true)
        #expect(mockPersistence.savedTimeRemaining == 60.0)
        #expect(mockPersistence.savedEndDate == nil)
    }
    
    @Test("Stop signal from Coordinator triggers stopTimer")
    func stopSignalTriggersStopTimer() async throws {
        sut.toggleStartPause()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(sut.state == .running)
        #expect(sut.timeRemaining < 60.0)
        
        sut.toggleStartPause()
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(sut.state == .paused)
        
        stopSignal.send(())
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(sut.state == .idle)
        #expect(sut.timeRemaining == 60.0)
    }
    
    @Test("Background sync schedules notification if timer is running")
    func backgroundSyncSchedulesNotificationIfRunning() async throws {
        mockPersistence.fetchStateResult = (Date().addingTimeInterval(30), 30.0)
        
        sut = TimerViewModel(
            persistence: mockPersistence,
            notifications: mockNotifications,
            stopSignal: stopSignal.eraseToAnyPublisher()
        )
        
        while sut.state != .running {
            try await Task.sleep(nanoseconds: 10_000_000)
        }
        
        mockNotifications.didScheduleNotification = false
        sut.syncWithAppLifecycle(isActive: false)
        
        #expect(
            mockNotifications.didScheduleNotification == true,
            "Notification should be scheduled when app goes to background with running timer"
        )
    }
}

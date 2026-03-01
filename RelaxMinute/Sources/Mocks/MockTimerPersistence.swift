//
//  MockTimerPersistence.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 01.03.2026.
//


import Foundation
@testable import RelaxMinute

final class MockTimerPersistence: TimerPersistenceProtocol {
    var savedEndDate: Date?
    var savedTimeRemaining: TimeInterval = 60.0
    var fetchStateResult: (Date?, TimeInterval) = (nil, 60.0)
    
    func saveState(endDate: Date?, timeRemaining: TimeInterval) {
        savedEndDate = endDate
        savedTimeRemaining = timeRemaining
    }
    
    func fetchState() -> (endDate: Date?, timeRemaining: TimeInterval) {
        return fetchStateResult
    }
}

//
//  UserDefaultsTimerPersistence.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//

import Foundation

final class UserDefaultsTimerPersistence: TimerPersistenceProtocol {
    private let endDateKey = "timer_end_date_key"
    private let remainingTimeKey = "timer_remaining_time_key"
    private let defaults = UserDefaults.standard
    
    func saveState(endDate: Date?, timeRemaining: TimeInterval) {
        defaults.set(endDate, forKey: endDateKey)
        defaults.set(timeRemaining, forKey: remainingTimeKey)
    }
    
    func fetchState() -> (endDate: Date?, timeRemaining: TimeInterval) {
        let date = defaults.object(forKey: endDateKey) as? Date
        let remaining = defaults.object(forKey: remainingTimeKey) as? TimeInterval ?? 60.0
        return (date, remaining == 0 ? 60.0 : remaining)
    }
}

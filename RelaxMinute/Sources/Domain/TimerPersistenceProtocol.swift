//
//  TimerPersistenceProtocol.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//

import Foundation

protocol TimerPersistenceProtocol {
    func saveState(endDate: Date?, timeRemaining: TimeInterval)
    func fetchState() -> (endDate: Date?, timeRemaining: TimeInterval)
}

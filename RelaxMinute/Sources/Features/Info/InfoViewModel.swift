//
//  InfoViewModel.swift
//  RelaxMinute
//
//  Created by Oleh Hulovatyi on 28.02.2026.
//

import Combine

@MainActor
final class InfoViewModel: ObservableObject {
    var onDismiss: (() -> Void)?
}

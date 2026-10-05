//
//  TodayCareDashboardViewModel.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import Foundation
import Combine

@MainActor
final class TodayCareDashboardViewModel: ObservableObject {

    @Published private(set) var tasks: [CareTask] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let getTodaysCareTasksUseCase: GetTodaysCareTasksUseCase

    init(
        getTodaysCareTasksUseCase: GetTodaysCareTasksUseCase
    ) {
        self.getTodaysCareTasksUseCase = getTodaysCareTasksUseCase
    }

    func loadTasks(for date: Date = Date()) {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            tasks = try getTodaysCareTasksUseCase.execute(for: date)
        } catch {
            tasks = []
            errorMessage = "Unable to load today's care tasks."
        }
    }
}

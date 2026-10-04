//
//  GetTodaysCareTasksUseCase.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation

final class GetTodaysCareTasksUseCase {

    private let careTaskRepository: CareTaskRepository

    init(careTaskRepository: CareTaskRepository) {
        self.careTaskRepository = careTaskRepository
    }

    func execute(for date: Date = Date()) throws -> [CareTask] {
        let tasks = try careTaskRepository.fetchCareTasks()

        let calendar = Calendar.current

        return tasks
            .filter {
                calendar.isDate($0.scheduledTime, inSameDayAs: date)
            }
            .sorted {
                $0.scheduledTime < $1.scheduledTime
            }
    }
}

//
//  GetCareHistoryUseCase.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation

final class GetCareHistoryUseCase {

    private let careActivityRecordRepository: CareActivityRecordRepository

    init(
        careActivityRecordRepository: CareActivityRecordRepository
    ) {
        self.careActivityRecordRepository = careActivityRecordRepository
    }

    func execute(
        for petStayID: UUID
    ) throws -> [CareActivityRecord] {

        let records = try careActivityRecordRepository
            .fetchCareActivityRecords()

        return records
            .filter {
                $0.petStayID == petStayID
            }
            .sorted {
                $0.completedAt > $1.completedAt
            }
    }
}

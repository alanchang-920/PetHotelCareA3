//
//  CareActivityRecordRepository.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/3.
//

import Foundation

protocol CareActivityRecordRepository {
    func fetchCareActivityRecords() throws -> [CareActivityRecord]
    func saveCareActivityRecord(_ record: CareActivityRecord) throws
    func deleteCareActivityRecord(id: UUID) throws
}

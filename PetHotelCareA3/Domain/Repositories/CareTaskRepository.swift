//
//  CareTaskRepository.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/3.
//

import Foundation

protocol CareTaskRepository {
    func fetchCareTasks() throws -> [CareTask]
    func saveCareTask(_ careTask: CareTask) throws
    func deleteCareTask(id: UUID) throws
}

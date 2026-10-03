//
//  PetRepository.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/3.
//

import Foundation

protocol PetRepository {
    func fetchPets() throws -> [Pet]
    func savePet(_ pet: Pet) throws
    func deletePet(id: UUID) throws
}


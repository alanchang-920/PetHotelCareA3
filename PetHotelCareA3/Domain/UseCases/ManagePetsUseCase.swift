//
//  ManagePetsUseCase.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/7.
//

import Foundation

final class ManagePetsUseCase {

    private let petRepository: PetRepository

    init(
        petRepository: PetRepository
    ) {
        self.petRepository = petRepository
    }

    func getPets() throws -> [Pet] {
        try petRepository.fetchPets()
    }

    func createPet(
        name: String,
        species: PetSpecies,
        breed: String,
        dateOfBirth: Date,
        ownerName: String,
        ownerPhoneNumber: String
    ) throws -> Pet {

        let owner = PetOwner(
            name: ownerName,
            phoneNumber: ownerPhoneNumber
        )

        let pet = Pet(
            name: name,
            species: species,
            breed: breed,
            dateOfBirth: dateOfBirth,
            owner: owner
        )

        try petRepository.savePet(pet)

        return pet
    }

    func deletePet(
        id: UUID
    ) throws {
        try petRepository.deletePet(id: id)
    }
}

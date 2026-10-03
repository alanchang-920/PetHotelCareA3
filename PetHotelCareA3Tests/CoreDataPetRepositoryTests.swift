//
//  CoreDataPetRepositoryTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/3.
//

import Testing
import CoreData
@testable import PetHotelCareA3

@MainActor
struct CoreDataPetRepositoryTests {

    private func makeRepository() -> CoreDataPetRepository {
        let persistenceController = PersistenceController(inMemory: true)

        return CoreDataPetRepository(
            context: persistenceController.container.viewContext
        )
    }

    @Test
    func saveAndFetchPet() throws {

        let repository = makeRepository()

        let owner = PetOwner(
            name: "Alan",
            phoneNumber: "0400000000"
        )

        let pet = Pet(
            name: "Milo",
            species: .dog,
            breed: "Labrador",
            dateOfBirth: Date(),
            owner: owner
        )

        try repository.savePet(pet)

        let pets = try repository.fetchPets()

        #expect(pets.count == 1)
        #expect(pets.first?.id == pet.id)
        #expect(pets.first?.name == "Milo")
        #expect(pets.first?.species == .dog)
        #expect(pets.first?.breed == "Labrador")
        #expect(pets.first?.owner.id == owner.id)
        #expect(pets.first?.owner.name == "Alan")
        #expect(pets.first?.owner.phoneNumber == "0400000000")
    }

    @Test
    func deletePet() throws {
 
        let repository = makeRepository()

        let owner = PetOwner(
            name: "Alan",
            phoneNumber: "0400000000"
        )

        let pet = Pet(
            name: "Milo",
            species: .dog,
            breed: "Labrador",
            dateOfBirth: Date(),
            owner: owner
        )

        try repository.savePet(pet)

        var pets = try repository.fetchPets()
        #expect(pets.count == 1)

        try repository.deletePet(id: pet.id)

        pets = try repository.fetchPets()
        #expect(pets.isEmpty)
    }
}

//
//  CoreDataPetRepositoryTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/3.
//

import XCTest
import CoreData
@testable import PetHotelCareA3

final class CoreDataPetRepositoryTests: XCTestCase {

    private var persistenceController: PersistenceController!
    private var repository: CoreDataPetRepository!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)

        repository = CoreDataPetRepository(
            context: persistenceController.container.viewContext
        )
    }

    override func tearDownWithError() throws {
        repository = nil
        persistenceController = nil
    }
    
    func testSaveAndFetchPet() throws {
        let owner = PetOwner(
            name: "John Smith",
            phoneNumber: "0400123456"
        )

        let pet = Pet(
            name: "Milo",
            species: .dog,
            breed: "Golden Retriever",
            dateOfBirth: Date(),
            owner: owner
        )

        try repository.savePet(pet)

        let pets = try repository.fetchPets()

        XCTAssertEqual(pets.count, 1)
        XCTAssertEqual(pets.first?.id, pet.id)
        XCTAssertEqual(pets.first?.name, "Milo")
        XCTAssertEqual(pets.first?.species, .dog)
        XCTAssertEqual(pets.first?.breed, "Golden Retriever")
        XCTAssertEqual(pets.first?.owner.name, "John Smith")
        XCTAssertEqual(pets.first?.owner.phoneNumber, "0400123456")
    }
    
    func testDeletePet() throws {
        let owner = PetOwner(
            name: "John Smith",
            phoneNumber: "0400123456"
        )

        let pet = Pet(
            name: "Milo",
            species: .dog,
            breed: "Golden Retriever",
            dateOfBirth: Date(),
            owner: owner
        )

        try repository.savePet(pet)

        var pets = try repository.fetchPets()
        XCTAssertEqual(pets.count, 1)

        try repository.deletePet(id: pet.id)

        pets = try repository.fetchPets()
        XCTAssertEqual(pets.count, 0)
    }
}

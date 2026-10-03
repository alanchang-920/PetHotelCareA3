//
//  CoreDataPetStayRepositoryTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/3.
//

import XCTest
import CoreData
@testable import PetHotelCareA3

final class CoreDataPetStayRepositoryTests: XCTestCase {

    private var persistenceController: PersistenceController!
    private var repository: CoreDataPetStayRepository!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)

        repository = CoreDataPetStayRepository(
            context: persistenceController.container.viewContext
        )
    }

    override func tearDownWithError() throws {
        repository = nil
        persistenceController = nil
    }

    func testSaveAndFetchPetStay() throws {
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

        let petStay = PetStay(
            pet: pet,
            roomNumber: "A101",
            checkInDate: Date(),
            checkOutDate: Date().addingTimeInterval(86400),
            feedingInstructions: "Feed twice daily",
            careNotes: "Friendly dog"
        )

        try repository.savePetStay(petStay)

        let stays = try repository.fetchPetStays()

        XCTAssertEqual(stays.count, 1)
        XCTAssertEqual(stays.first?.id, petStay.id)
        XCTAssertEqual(stays.first?.roomNumber, "A101")
        XCTAssertEqual(stays.first?.feedingInstructions, "Feed twice daily")
        XCTAssertEqual(stays.first?.careNotes, "Friendly dog")

        XCTAssertEqual(stays.first?.pet.id, pet.id)
        XCTAssertEqual(stays.first?.pet.name, "Milo")
        XCTAssertEqual(stays.first?.pet.species, .dog)
        XCTAssertEqual(stays.first?.pet.breed, "Golden Retriever")

        XCTAssertEqual(stays.first?.pet.owner.id, owner.id)
        XCTAssertEqual(stays.first?.pet.owner.name, "John Smith")
        XCTAssertEqual(stays.first?.pet.owner.phoneNumber, "0400123456")
    }

    func testDeletePetStay() throws {
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

        let petStay = PetStay(
            pet: pet,
            roomNumber: "A101",
            checkInDate: Date(),
            checkOutDate: Date().addingTimeInterval(86400),
            feedingInstructions: "Feed twice daily",
            careNotes: "Friendly dog"
        )

        try repository.savePetStay(petStay)

        var stays = try repository.fetchPetStays()
        XCTAssertEqual(stays.count, 1)

        try repository.deletePetStay(id: petStay.id)

        stays = try repository.fetchPetStays()
        XCTAssertEqual(stays.count, 0)
    }
}

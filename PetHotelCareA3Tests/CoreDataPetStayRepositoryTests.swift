//
//  CoreDataPetStayRepositoryTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/3.
//

import Testing
import CoreData
@testable import PetHotelCareA3

@MainActor
struct CoreDataPetStayRepositoryTests {

    private func makeRepository() -> CoreDataPetStayRepository {
        let persistenceController = PersistenceController(inMemory: true)

        return CoreDataPetStayRepository(
            context: persistenceController.container.viewContext
        )
    }

    private func makePetStay() -> PetStay {
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

        return PetStay(
            pet: pet,
            roomNumber: "A101",
            checkInDate: Date(),
            checkOutDate: Date().addingTimeInterval(86400),
            feedingInstructions: "Feed twice daily",
            careNotes: "Friendly dog"
        )
    }

    @Test
    func saveAndFetchPetStay() throws {
        
        let repository = makeRepository()
        let petStay = makePetStay()

        try repository.savePetStay(petStay)

        let petStays = try repository.fetchPetStays()

        #expect(petStays.count == 1)
        #expect(petStays.first?.id == petStay.id)
        #expect(petStays.first?.roomNumber == "A101")
        #expect(petStays.first?.feedingInstructions == "Feed twice daily")
        #expect(petStays.first?.careNotes == "Friendly dog")

        #expect(petStays.first?.pet.id == petStay.pet.id)
        #expect(petStays.first?.pet.name == "Milo")
        #expect(petStays.first?.pet.species == .dog)

        #expect(petStays.first?.pet.owner.id == petStay.pet.owner.id)
        #expect(petStays.first?.pet.owner.name == "Alan")
    }

    @Test
    func deletePetStay() throws {
        let repository = makeRepository()
        let petStay = makePetStay()

        try repository.savePetStay(petStay)

        var petStays = try repository.fetchPetStays()
        #expect(petStays.count == 1)

        try repository.deletePetStay(id: petStay.id)

        petStays = try repository.fetchPetStays()
        #expect(petStays.isEmpty)
    }
}

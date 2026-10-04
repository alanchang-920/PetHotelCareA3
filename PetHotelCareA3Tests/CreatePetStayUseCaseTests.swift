//
//  CreatePetStayUseCaseTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation
import Testing
@testable import PetHotelCareA3

private final class MockCreatePetStayRepository: PetStayRepository {

    var petStays: [PetStay] = []

    func fetchPetStays() throws -> [PetStay] {
        petStays
    }

    func savePetStay(_ petStay: PetStay) throws {
        petStays.append(petStay)
    }

    func deletePetStay(id: UUID) throws {
        petStays.removeAll { $0.id == id }
    }
}

struct CreatePetStayUseCaseTests {
    
    private func makePet() -> Pet {
        let owner = PetOwner(
            name: "John Smith",
            phoneNumber: "0400000000"
        )

        return Pet(
            name: "Milo",
            species: .dog,
            breed: "Labrador",
            dateOfBirth: Date(),
            owner: owner
        )
    }
    
    @Test
    func createsPetStayWithValidDates() throws {

        let repository = MockCreatePetStayRepository()
        let useCase = CreatePetStayUseCase(
            petStayRepository: repository
        )

        let pet = makePet()

        let calendar = Calendar.current

        let checkInDate = calendar.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 4
            )
        )!

        let checkOutDate = calendar.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 8
            )
        )!

        let result = try useCase.execute(
            pet: pet,
            roomNumber: "204",
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            feedingInstructions: "Feed twice daily",
            careNotes: "Sensitive stomach"
        )

        #expect(repository.petStays.count == 1)

        #expect(result.pet.id == pet.id)
        #expect(result.roomNumber == "204")
        #expect(result.checkInDate == checkInDate)
        #expect(result.checkOutDate == checkOutDate)
        #expect(result.feedingInstructions == "Feed twice daily")
        #expect(result.careNotes == "Sensitive stomach")

        #expect(repository.petStays.first?.id == result.id)
    }
    
    @Test
    func rejectsStayWhenCheckOutEqualsCheckIn() throws {
        
        let repository = MockCreatePetStayRepository()
        let useCase = CreatePetStayUseCase(
            petStayRepository: repository
        )

        let pet = makePet()

        let date = Calendar.current.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 4
            )
        )!

        #expect(throws: CreatePetStayError.invalidStayDates) {
            try useCase.execute(
                pet: pet,
                roomNumber: "204",
                checkInDate: date,
                checkOutDate: date,
                feedingInstructions: "Feed twice daily",
                careNotes: ""
            )
        }

        #expect(repository.petStays.isEmpty)
    }
    
    @Test
    func rejectsStayWhenCheckOutIsBeforeCheckIn() throws {

        let repository = MockCreatePetStayRepository()
        let useCase = CreatePetStayUseCase(
            petStayRepository: repository
        )

        let pet = makePet()

        let calendar = Calendar.current

        let checkInDate = calendar.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 8
            )
        )!

        let checkOutDate = calendar.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 4
            )
        )!

        #expect(throws: CreatePetStayError.invalidStayDates) {
            try useCase.execute(
                pet: pet,
                roomNumber: "204",
                checkInDate: checkInDate,
                checkOutDate: checkOutDate,
                feedingInstructions: "Feed twice daily",
                careNotes: ""
            )
        }

        #expect(repository.petStays.isEmpty)
    }
}

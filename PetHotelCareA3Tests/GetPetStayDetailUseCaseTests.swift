//
//  GetPetStayDetailUseCaseTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation
import Testing
@testable import PetHotelCareA3

private final class MockPetStayDetailRepository: PetStayRepository {

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

struct GetPetStayDetailUseCaseTests {
    
    private func makePetStay(
        roomNumber: String,
        petName: String
    ) -> PetStay {

        let owner = PetOwner(
            name: "Test Owner",
            phoneNumber: "0400000000"
        )

        let pet = Pet(
            name: petName,
            species: .dog,
            breed: "Labrador",
            dateOfBirth: Date(),
            owner: owner
        )

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

        return PetStay(
            pet: pet,
            roomNumber: roomNumber,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            feedingInstructions: "Feed twice daily",
            careNotes: "Test care notes"
        )
    }
    
    @Test
    func returnsPetStayForMatchingID() throws {

        let repository = MockPetStayDetailRepository()
        let useCase = GetPetStayDetailUseCase(
            petStayRepository: repository
        )

        let targetStay = makePetStay(
            roomNumber: "204",
            petName: "Milo"
        )

        let otherStay = makePetStay(
            roomNumber: "101",
            petName: "Luna"
        )

        repository.petStays = [
            otherStay,
            targetStay
        ]

        let result = try useCase.execute(
            petStayID: targetStay.id
        )

        #expect(result.id == targetStay.id)
        #expect(result.pet.name == "Milo")
        #expect(result.roomNumber == "204")
    }
    
    @Test
    func throwsWhenPetStayDoesNotExist() throws {

        let repository = MockPetStayDetailRepository()
        let useCase = GetPetStayDetailUseCase(
            petStayRepository: repository
        )

        repository.petStays = [
            makePetStay(
                roomNumber: "204",
                petName: "Milo"
            )
        ]

        let unknownID = UUID()

        #expect(throws: PetStayDetailError.petStayNotFound) {
            try useCase.execute(
                petStayID: unknownID
            )
        }
    }
}

//
//  GetCurrentPetStaysUseCaseTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation
import Testing
@testable import PetHotelCareA3

private final class MockPetStayRepository: PetStayRepository {

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

struct GetCurrentPetStaysUseCaseTests {
    
    private func makePetStay(
        roomNumber: String,
        checkInDate: Date,
        checkOutDate: Date
    ) -> PetStay {

        let owner = PetOwner(
            name: "Test Owner",
            phoneNumber: "0400000000"
        )

        let pet = Pet(
            name: "Test Pet",
            species: .dog,
            breed: "Labrador",
            dateOfBirth: Date(),
            owner: owner
        )

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
    func returnsOnlyCurrentPetStays() throws {

        let repository = MockPetStayRepository()

        let useCase = GetCurrentPetStaysUseCase(
            petStayRepository: repository
        )

        let calendar = Calendar.current

        let selectedDate = calendar.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 4,
                hour: 12
            )
        )!

        let currentStay = makePetStay(
            roomNumber: "102",
            checkInDate: calendar.date(
                byAdding: .day,
                value: -1,
                to: selectedDate
            )!,
            checkOutDate: calendar.date(
                byAdding: .day,
                value: 1,
                to: selectedDate
            )!
        )

        let pastStay = makePetStay(
            roomNumber: "101",
            checkInDate: calendar.date(
                byAdding: .day,
                value: -3,
                to: selectedDate
            )!,
            checkOutDate: calendar.date(
                byAdding: .day,
                value: -1,
                to: selectedDate
            )!
        )

        let futureStay = makePetStay(
            roomNumber: "103",
            checkInDate: calendar.date(
                byAdding: .day,
                value: 1,
                to: selectedDate
            )!,
            checkOutDate: calendar.date(
                byAdding: .day,
                value: 3,
                to: selectedDate
            )!
        )

        repository.petStays = [
            currentStay,
            pastStay,
            futureStay
        ]

        let result = try useCase.execute(for: selectedDate)

        #expect(result.count == 1)
        #expect(result.first?.id == currentStay.id)
    }
    
    @Test
    func sortsCurrentPetStaysByRoomNumber() throws {

        let repository = MockPetStayRepository()

        let useCase = GetCurrentPetStaysUseCase(
            petStayRepository: repository
        )

        let calendar = Calendar.current

        let selectedDate = calendar.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 4,
                hour: 12
            )
        )!

        let checkInDate = calendar.date(
            byAdding: .day,
            value: -1,
            to: selectedDate
        )!

        let checkOutDate = calendar.date(
            byAdding: .day,
            value: 1,
            to: selectedDate
        )!

        let room205 = makePetStay(
            roomNumber: "205",
            checkInDate: checkInDate,
            checkOutDate: checkOutDate
        )

        let room101 = makePetStay(
            roomNumber: "101",
            checkInDate: checkInDate,
            checkOutDate: checkOutDate
        )

        let room103 = makePetStay(
            roomNumber: "103",
            checkInDate: checkInDate,
            checkOutDate: checkOutDate
        )

        repository.petStays = [
            room205,
            room101,
            room103
        ]

        let result = try useCase.execute(for: selectedDate)

        #expect(result.count == 3)
        #expect(result[0].roomNumber == "101")
        #expect(result[1].roomNumber == "103")
        #expect(result[2].roomNumber == "205")
    }
}

//
//  CreatePetStayViewModel.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import Foundation
import Combine

@MainActor
final class CreatePetStayViewModel: ObservableObject {

    @Published var roomNumber: String = ""
    @Published var checkInDate: Date = Date()
    @Published var checkOutDate: Date = Calendar.current.date(
        byAdding: .day,
        value: 1,
        to: Date()
    ) ?? Date()

    @Published var feedingInstructions: String = ""
    @Published var careNotes: String = ""

    @Published private(set) var isSaving = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var createdPetStay: PetStay?

    private let createPetStayUseCase: CreatePetStayUseCase

    init(
        createPetStayUseCase: CreatePetStayUseCase
    ) {
        self.createPetStayUseCase = createPetStayUseCase
    }

    func createPetStay(for pet: Pet) {

        isSaving = true
        errorMessage = nil
        createdPetStay = nil

        defer {
            isSaving = false
        }

        do {
            createdPetStay = try createPetStayUseCase.execute(
                pet: pet,
                roomNumber: roomNumber,
                checkInDate: checkInDate,
                checkOutDate: checkOutDate,
                feedingInstructions: feedingInstructions,
                careNotes: careNotes
            )
        } catch CreatePetStayError.invalidStayDates {
            errorMessage = "Check-out date must be after check-in date."
        } catch {
            errorMessage = "Unable to create pet stay."
        }
    }

    func resetForm() {
        roomNumber = ""
        checkInDate = Date()
        checkOutDate = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: Date()
        ) ?? Date()

        feedingInstructions = ""
        careNotes = ""

        errorMessage = nil
        createdPetStay = nil
    }
}

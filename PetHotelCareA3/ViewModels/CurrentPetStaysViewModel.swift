//
//  CurrentPetStaysViewModel.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import Foundation
import Combine

@MainActor
final class CurrentPetStaysViewModel: ObservableObject {

    @Published private(set) var petStays: [PetStay] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let getCurrentPetStaysUseCase: GetCurrentPetStaysUseCase

    init(
        getCurrentPetStaysUseCase: GetCurrentPetStaysUseCase
    ) {
        self.getCurrentPetStaysUseCase = getCurrentPetStaysUseCase
    }

    func loadCurrentPetStays(
        for date: Date = Date()
    ) {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            petStays = try getCurrentPetStaysUseCase.execute(
                for: date
            )
        } catch {
            petStays = []
            errorMessage = "Unable to load current pet stays."
        }
    }
}

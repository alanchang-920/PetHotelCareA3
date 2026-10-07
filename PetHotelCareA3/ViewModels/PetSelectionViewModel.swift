//
//  PetSelectionViewModel.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/7.
//

import Foundation

import Foundation
import Combine

@MainActor
final class PetSelectionViewModel: ObservableObject {

    @Published private(set) var pets: [Pet] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isSaving = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var createdPet: Pet?

    private let managePetsUseCase: ManagePetsUseCase

    init(
        managePetsUseCase: ManagePetsUseCase
    ) {
        self.managePetsUseCase = managePetsUseCase
    }

    func loadPets() {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            pets = try managePetsUseCase.getPets()
        } catch {
            pets = []
            errorMessage = "Unable to load pets."
        }
    }

    func createPet(
        name: String,
        species: PetSpecies,
        breed: String,
        dateOfBirth: Date,
        ownerName: String,
        ownerPhoneNumber: String
    ) {
        isSaving = true
        errorMessage = nil
        createdPet = nil

        defer {
            isSaving = false
        }

        do {
            let pet = try managePetsUseCase.createPet(
                name: name,
                species: species,
                breed: breed,
                dateOfBirth: dateOfBirth,
                ownerName: ownerName,
                ownerPhoneNumber: ownerPhoneNumber
            )

            createdPet = pet
            loadPets()
        } catch {
            errorMessage = "Unable to create pet."
        }
    }
}

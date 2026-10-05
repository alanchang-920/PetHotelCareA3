//
//  PetStayDetailViewModel.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import Foundation
import Combine

@MainActor
final class PetStayDetailViewModel: ObservableObject {

    @Published private(set) var petStay: PetStay?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let getPetStayDetailUseCase: GetPetStayDetailUseCase

    init(
        getPetStayDetailUseCase: GetPetStayDetailUseCase
    ) {
        self.getPetStayDetailUseCase = getPetStayDetailUseCase
    }

    func loadPetStay(id: UUID) {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            petStay = try getPetStayDetailUseCase.execute(
                petStayID: id
            )
        } catch PetStayDetailError.petStayNotFound {
            petStay = nil
            errorMessage = "Pet stay could not be found."
        } catch {
            petStay = nil
            errorMessage = "Unable to load pet stay details."
        }
    }
}

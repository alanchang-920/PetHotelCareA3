//
//  CareHistoryViewModel.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import Foundation
import Combine

@MainActor
final class CareHistoryViewModel: ObservableObject {

    @Published private(set) var records: [CareActivityRecord] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let getCareHistoryUseCase: GetCareHistoryUseCase

    init(
        getCareHistoryUseCase: GetCareHistoryUseCase
    ) {
        self.getCareHistoryUseCase = getCareHistoryUseCase
    }

    func loadHistory(for petStayID: UUID) {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            records = try getCareHistoryUseCase.execute(
                for: petStayID
            )
        } catch {
            records = []
            errorMessage = "Unable to load care history."
        }
    }
}

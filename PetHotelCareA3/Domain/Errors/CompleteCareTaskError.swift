//
//  CompleteCareTaskError.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/7.
//

import Foundation

enum CompleteCareTaskError: Error, Equatable {
    case careTaskNotFound
    case careTaskAlreadyCompleted
}

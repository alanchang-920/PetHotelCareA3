//
//  Pet.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/2.
//

import Foundation

struct Pet: Identifiable, Equatable {
    let id: UUID
    var name: String
    var species: PetSpecies
    var breed: String
    var dateOfBirth: Date
    var owner: PetOwner

    init(
        id: UUID = UUID(),
        name: String,
        species: PetSpecies,
        breed: String,
        dateOfBirth: Date,
        owner: PetOwner
    ) {
        self.id = id
        self.name = name
        self.species = species
        self.breed = breed
        self.dateOfBirth = dateOfBirth
        self.owner = owner
    }
}

enum PetSpecies: String, CaseIterable {
    case dog = "Dog"
    case cat = "Cat"
}

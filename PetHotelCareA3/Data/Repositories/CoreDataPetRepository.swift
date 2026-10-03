//
//  CoreDataPetRepository.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/3.
//

import CoreData

final class CoreDataPetRepository: PetRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchPets() throws -> [Pet] {
        let request = PetEntity.fetchRequest()
        let entities = try context.fetch(request)

        return entities.map { entity in
            let ownerEntity = entity.owner

            let owner = PetOwner(
                id: ownerEntity?.id ?? UUID(),
                name: ownerEntity?.name ?? "",
                phoneNumber: ownerEntity?.phoneNumber ?? ""
            )

            return Pet(
                id: entity.id ?? UUID(),
                name: entity.name ?? "",
                species: PetSpecies(rawValue: entity.species ?? "") ?? .dog,
                breed: entity.breed ?? "",
                dateOfBirth: entity.dateOfBirth ?? Date(),
                owner: owner
            )
        }
    }
    
    func savePet(_ pet: Pet) throws {
        let petEntity = NSEntityDescription.insertNewObject(
            forEntityName: "PetEntity",
            into: context
        ) as! PetEntity

        petEntity.id = pet.id
        petEntity.name = pet.name
        petEntity.species = pet.species.rawValue
        petEntity.breed = pet.breed
        petEntity.dateOfBirth = pet.dateOfBirth

        let ownerEntity = NSEntityDescription.insertNewObject(
            forEntityName: "PetOwnerEntity",
            into: context
        ) as! PetOwnerEntity

        ownerEntity.id = pet.owner.id
        ownerEntity.name = pet.owner.name
        ownerEntity.phoneNumber = pet.owner.phoneNumber

        petEntity.owner = ownerEntity

        try context.save()
    }
    
    func deletePet(id: UUID) throws {
        let request = PetEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        if let entity = try context.fetch(request).first {
            context.delete(entity)
            try context.save()
        }
    }
}

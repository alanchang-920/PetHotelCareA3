//
//  CoreDataPetStayRepository.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/3.
//

import CoreData

final class CoreDataPetStayRepository: PetStayRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchPetStays() throws -> [PetStay] {
        let request = PetStayEntity.fetchRequest()
        let entities = try context.fetch(request)

        return entities.compactMap { entity in
            guard let petEntity = entity.pet else {
                return nil
            }

            let ownerEntity = petEntity.owner

            let owner = PetOwner(
                id: ownerEntity?.id ?? UUID(),
                name: ownerEntity?.name ?? "",
                phoneNumber: ownerEntity?.phoneNumber ?? ""
            )

            let pet = Pet(
                id: petEntity.id ?? UUID(),
                name: petEntity.name ?? "",
                species:
                    PetSpecies(
                        rawValue: petEntity.species ?? ""
                    ) ?? .dog,
                breed: petEntity.breed ?? "",
                dateOfBirth:
                    petEntity.dateOfBirth ?? Date(),
                owner: owner
            )

            return PetStay(
                id: entity.id ?? UUID(),
                pet: pet,
                roomNumber: entity.roomNumber ?? "",
                checkInDate:
                    entity.checkInDate ?? Date(),
                checkOutDate:
                    entity.checkOutDate ?? Date(),
                feedingInstructions:
                    entity.feedingInstructions ?? "",
                careNotes:
                    entity.careNotes ?? ""
            )
        }
    }

    func savePetStay(
        _ petStay: PetStay
    ) throws {
        let stayEntity =
            NSEntityDescription.insertNewObject(
                forEntityName: "PetStayEntity",
                into: context
            ) as! PetStayEntity

        stayEntity.id = petStay.id
        stayEntity.roomNumber =
            petStay.roomNumber
        stayEntity.checkInDate =
            petStay.checkInDate
        stayEntity.checkOutDate =
            petStay.checkOutDate
        stayEntity.feedingInstructions =
            petStay.feedingInstructions
        stayEntity.careNotes =
            petStay.careNotes

        let petEntity =
            try findOrCreatePetEntity(
                for: petStay.pet
            )

        stayEntity.pet = petEntity

        try context.save()
    }

    func deletePetStay(
        id: UUID
    ) throws {
        let request =
            PetStayEntity.fetchRequest()

        request.predicate =
            NSPredicate(
                format: "id == %@",
                id as CVarArg
            )

        if let entity =
            try context.fetch(request).first {
            context.delete(entity)
            try context.save()
        }
    }

    private func findOrCreatePetEntity(
        for pet: Pet
    ) throws -> PetEntity {
        let request =
            PetEntity.fetchRequest()

        request.predicate =
            NSPredicate(
                format: "id == %@",
                pet.id as CVarArg
            )

        request.fetchLimit = 1

        if let existingPet =
            try context.fetch(request).first {
            return existingPet
        }

        let petEntity =
            NSEntityDescription.insertNewObject(
                forEntityName: "PetEntity",
                into: context
            ) as! PetEntity

        petEntity.id = pet.id
        petEntity.name = pet.name
        petEntity.species = pet.species.rawValue
        petEntity.breed = pet.breed
        petEntity.dateOfBirth = pet.dateOfBirth

        let ownerEntity =
            NSEntityDescription.insertNewObject(
                forEntityName: "PetOwnerEntity",
                into: context
            ) as! PetOwnerEntity

        ownerEntity.id = pet.owner.id
        ownerEntity.name = pet.owner.name
        ownerEntity.phoneNumber =
            pet.owner.phoneNumber

        petEntity.owner = ownerEntity

        return petEntity
    }
}

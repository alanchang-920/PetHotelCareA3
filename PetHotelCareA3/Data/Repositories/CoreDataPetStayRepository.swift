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
                species: PetSpecies(rawValue: petEntity.species ?? "") ?? .dog,
                breed: petEntity.breed ?? "",
                dateOfBirth: petEntity.dateOfBirth ?? Date(),
                owner: owner
            )

            return PetStay(
                id: entity.id ?? UUID(),
                pet: pet,
                roomNumber: entity.roomNumber ?? "",
                checkInDate: entity.checkInDate ?? Date(),
                checkOutDate: entity.checkOutDate ?? Date(),
                feedingInstructions: entity.feedingInstructions ?? "",
                careNotes: entity.careNotes ?? ""
            )
        }
    }

    func savePetStay(_ petStay: PetStay) throws {
        let entity = NSEntityDescription.insertNewObject(
            forEntityName: "PetStayEntity",
            into: context
        ) as! PetStayEntity

        entity.id = petStay.id
        entity.roomNumber = petStay.roomNumber
        entity.checkInDate = petStay.checkInDate
        entity.checkOutDate = petStay.checkOutDate
        entity.feedingInstructions = petStay.feedingInstructions
        entity.careNotes = petStay.careNotes

        let petEntity = NSEntityDescription.insertNewObject(
            forEntityName: "PetEntity",
            into: context
        ) as! PetEntity

        petEntity.id = petStay.pet.id
        petEntity.name = petStay.pet.name
        petEntity.species = petStay.pet.species.rawValue
        petEntity.breed = petStay.pet.breed
        petEntity.dateOfBirth = petStay.pet.dateOfBirth

        let ownerEntity = NSEntityDescription.insertNewObject(
            forEntityName: "PetOwnerEntity",
            into: context
        ) as! PetOwnerEntity

        ownerEntity.id = petStay.pet.owner.id
        ownerEntity.name = petStay.pet.owner.name
        ownerEntity.phoneNumber = petStay.pet.owner.phoneNumber

        petEntity.owner = ownerEntity
        entity.pet = petEntity

        try context.save()
    }

    func deletePetStay(id: UUID) throws {
        let request = PetStayEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        if let entity = try context.fetch(request).first {
            context.delete(entity)
            try context.save()
        }
    }
}

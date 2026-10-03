//
//  CoreDataCareTaskRepository.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/3.
//

import CoreData

final class CoreDataCareTaskRepository: CareTaskRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchCareTasks() throws -> [CareTask] {
        let request = CareTaskEntity.fetchRequest()
        let entities = try context.fetch(request)

        return entities.compactMap { entity in
            guard
                let id = entity.id,
                let petStayID = entity.petStayID,
                let typeString = entity.type,
                let type = CareTaskType(rawValue: typeString),
                let scheduledTime = entity.scheduledTime
            else {
                return nil
            }

            return CareTask(
                id: id,
                petStayID: petStayID,
                type: type,
                scheduledTime: scheduledTime,
                instructions: entity.instructions ?? "",
                isCompleted: entity.isCompleted
            )
        }
    }

    func saveCareTask(_ careTask: CareTask) throws {
        let entity = NSEntityDescription.insertNewObject(
            forEntityName: "CareTaskEntity",
            into: context
        ) as! CareTaskEntity

        entity.id = careTask.id
        entity.petStayID = careTask.petStayID
        entity.type = careTask.type.rawValue
        entity.scheduledTime = careTask.scheduledTime
        entity.instructions = careTask.instructions
        entity.isCompleted = careTask.isCompleted

        try context.save()
    }

    func deleteCareTask(id: UUID) throws {
        let request = CareTaskEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )

        if let entity = try context.fetch(request).first {
            context.delete(entity)
            try context.save()
        }
    }
}

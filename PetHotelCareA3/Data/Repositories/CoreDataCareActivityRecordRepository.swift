//
//  CoreDataCareActivityRecordRepository.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/3.
//

import CoreData

final class CoreDataCareActivityRecordRepository: CareActivityRecordRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchCareActivityRecords() throws -> [CareActivityRecord] {

        let request = CareActivityRecordEntity.fetchRequest()
        let entities = try context.fetch(request)

        return entities.compactMap { entity in

            guard
                let id = entity.id,
                let petStayID = entity.petStayID,
                let careTaskID = entity.careTaskID,
                let taskTypeString = entity.taskType,
                let taskType = CareTaskType(rawValue: taskTypeString),
                let completedAt = entity.completedAt,
                let staffEntity = entity.completedBy,
                let staffID = staffEntity.id,
                let staffName = staffEntity.name
            else {
                return nil
            }

            let staffMember = StaffMember(
                id: staffID,
                name: staffName
            )

            return CareActivityRecord(
                id: id,
                petStayID: petStayID,
                careTaskID: careTaskID,
                taskType: taskType,
                completedBy: staffMember,
                completedAt: completedAt,
                notes: entity.notes ?? ""
            )
        }
    }

    func saveCareActivityRecord(_ record: CareActivityRecord) throws {

        let entity = NSEntityDescription.insertNewObject(
            forEntityName: "CareActivityRecordEntity",
            into: context
        ) as! CareActivityRecordEntity

        entity.id = record.id
        entity.petStayID = record.petStayID
        entity.careTaskID = record.careTaskID
        entity.taskType = record.taskType.rawValue
        entity.completedAt = record.completedAt
        entity.notes = record.notes

        let staffEntity = NSEntityDescription.insertNewObject(
            forEntityName: "StaffMemberEntity",
            into: context
        ) as! StaffMemberEntity

        staffEntity.id = record.completedBy.id
        staffEntity.name = record.completedBy.name

        entity.completedBy = staffEntity

        try context.save()
    }

    func deleteCareActivityRecord(id: UUID) throws {

        let request = CareActivityRecordEntity.fetchRequest()

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

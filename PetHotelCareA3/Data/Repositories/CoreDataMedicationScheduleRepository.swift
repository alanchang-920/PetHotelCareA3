//
//  CoreDataMedicationScheduleRepository.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/3.
//

import CoreData

final class CoreDataMedicationScheduleRepository: MedicationScheduleRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchMedicationSchedules() throws -> [MedicationSchedule] {
        let request = MedicationScheduleEntity.fetchRequest()
        let entities = try context.fetch(request)

        return entities.compactMap { entity in
            guard
                let id = entity.id,
                let petStayID = entity.petStayID,
                let medicationName = entity.medicationName,
                let dosage = entity.dosage,
                let scheduledTime = entity.scheduledTime
            else {
                return nil
            }

            return MedicationSchedule(
                id: id,
                petStayID: petStayID,
                medicationName: medicationName,
                dosage: dosage,
                scheduledTime: scheduledTime,
                minimumIntervalHours: entity.minimumIntervalHours
            )
        }
    }

    func saveMedicationSchedule(_ schedule: MedicationSchedule) throws {
        let entity = NSEntityDescription.insertNewObject(
            forEntityName: "MedicationScheduleEntity",
            into: context
        ) as! MedicationScheduleEntity

        entity.id = schedule.id
        entity.petStayID = schedule.petStayID
        entity.medicationName = schedule.medicationName
        entity.dosage = schedule.dosage
        entity.scheduledTime = schedule.scheduledTime
        entity.minimumIntervalHours = schedule.minimumIntervalHours

        try context.save()
    }

    func deleteMedicationSchedule(id: UUID) throws {
        let request = MedicationScheduleEntity.fetchRequest()

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

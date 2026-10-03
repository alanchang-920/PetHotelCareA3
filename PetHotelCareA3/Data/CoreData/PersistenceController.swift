//
//  PersistenceController.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/3.
//

import CoreData

/// Manages the Core Data stack for the application.
///
/// This controller is responsible for creating and configuring
/// the persistent container used to store the pet hotel's data.
final class PersistenceController {

    /// Shared persistence controller used by the application.
    static let shared = PersistenceController()

    /// Core Data container for the application.
    let container: NSPersistentContainer

    /// Creates and configures the Core Data persistent container.
    init(inMemory: Bool = false) {

        container = NSPersistentContainer(name: "PetHotelCareModel")

        // Use an in-memory store when required, such as during testing.
        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load Core Data store: \(error)")
            }
        }

        // Automatically merge changes made in other contexts.
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

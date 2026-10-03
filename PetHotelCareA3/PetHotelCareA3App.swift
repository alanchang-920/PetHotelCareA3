//
//  PetHotelCareA3App.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/2.
//

import SwiftUI
import CoreData

@main
struct PetHotelCareA3App: App {

    // Shared Core Data persistence controller.
    private let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext
                )
        }
    }
}

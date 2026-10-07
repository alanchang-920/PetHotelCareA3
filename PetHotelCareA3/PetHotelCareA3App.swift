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

    private let persistenceController: PersistenceController
    private let appContainer: AppContainer

    init() {
        let persistenceController = PersistenceController.shared

        self.persistenceController = persistenceController

        self.appContainer = AppContainer(
            persistenceController: persistenceController
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                appContainer: appContainer
            )
            .environment(
                \.managedObjectContext,
                persistenceController.container.viewContext
            )
        }
    }
}

//
//  ContentView.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/2.
//

import SwiftUI

struct ContentView: View {

    let appContainer: AppContainer

    var body: some View {
        TabView {

            NavigationStack {
                TodayCareDashboardView(
                    viewModel:
                        appContainer.makeTodayCareDashboardViewModel()
                )
            }
            .tabItem {
                Label(
                    "Today's Care",
                    systemImage: "checklist"
                )
            }

            NavigationStack {
                CurrentPetStaysView(
                    viewModel:
                        appContainer.makeCurrentPetStaysViewModel(),
                    appContainer: appContainer
                )
            }
            .tabItem {
                Label(
                    "Current Stays",
                    systemImage: "house"
                )
            }
        }
    }
}

#Preview {
    let persistenceController =
        PersistenceController(
            inMemory: true
        )

    let appContainer =
        AppContainer(
            persistenceController:
                persistenceController
        )

    ContentView(
        appContainer: appContainer
    )
}

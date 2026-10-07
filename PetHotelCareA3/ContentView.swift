//
//  ContentView.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/2.
//

import SwiftUI

struct ContentView: View {

    let appContainer: AppContainer

    @State private var selectedTab = 0

    @ObservedObject private var quickActionManager =
        QuickActionManager.shared

    var body: some View {

        TabView(selection: $selectedTab) {

            NavigationStack {

                TodayCareDashboardView(
                    viewModel:
                        appContainer
                            .makeTodayCareDashboardViewModel()
                )
            }
            .tabItem {
                Label(
                    "Today's Care",
                    systemImage: "checklist"
                )
            }
            .tag(0)

            NavigationStack {

                CurrentPetStaysView(
                    viewModel:
                        appContainer
                            .makeCurrentPetStaysViewModel(),
                    appContainer: appContainer
                )
            }
            .tabItem {
                Label(
                    "Current Stays",
                    systemImage: "house"
                )
            }
            .tag(1)
        }
        .onOpenURL { url in
            handleDeepLink(url)
        }
        .onChange(
            of: quickActionManager.selectedTab
        ) { _, newValue in

            guard let newValue else {
                return
            }

            selectedTab = newValue

            quickActionManager.selectedTab = nil
        }
    }

    private func handleDeepLink(
        _ url: URL
    ) {

        guard url.scheme == "pethotelcare" else {
            return
        }

        switch url.host {

        case "today":
            selectedTab = 0

        case "stays":
            selectedTab = 1

        default:
            break
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

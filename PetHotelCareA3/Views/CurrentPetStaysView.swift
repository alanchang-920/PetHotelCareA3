//
//  CurrentPetStaysView.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import SwiftUI

struct CurrentPetStaysView: View {

    @ObservedObject var viewModel: CurrentPetStaysViewModel
    let appContainer: AppContainer

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                summarySection
                staysSection
            }
            .padding()
        }
        .navigationTitle("Current Stays")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                NavigationLink {
                    SelectPetView(
                        viewModel:
                            appContainer.makePetSelectionViewModel(),
                        appContainer: appContainer
                    )
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.loadCurrentPetStays()
        }
    }
}

private extension CurrentPetStaysView {

    var summarySection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Pet Stays")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Pets currently staying at the hotel")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 2) {
                Text("\(viewModel.petStays.count)")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Active")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Color(.secondarySystemBackground)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 14)
            )
        }
    }
}

private extension CurrentPetStaysView {

    @ViewBuilder
    var staysSection: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(
                    maxWidth: .infinity,
                    minHeight: 200
                )
        } else if let errorMessage = viewModel.errorMessage {
            errorView(message: errorMessage)
        } else if viewModel.petStays.isEmpty {
            emptyState
        } else {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.petStays) { stay in
                    NavigationLink {
                        PetStayDetailView(
                            viewModel:
                                appContainer.makePetStayDetailViewModel(),
                            petStayID: stay.id,
                            appContainer: appContainer
                        )
                    } label: {
                        stayCard(stay)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private extension CurrentPetStaysView {

    func stayCard(
        _ stay: PetStay
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack {
                Label(
                    "Room \(stay.roomNumber)",
                    systemImage: "door.left.hand.closed"
                )
                .font(.caption)
                .fontWeight(.semibold)

                Spacer()

                Text(speciesTitle(for: stay.pet))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Color(.tertiarySystemBackground)
                    )
                    .clipShape(Capsule())
            }

            HStack(spacing: 12) {
                Image(systemName: petIcon(for: stay.pet))
                    .font(.title2)
                    .frame(width: 44, height: 44)
                    .background(
                        Color(.tertiarySystemBackground)
                    )
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text(stay.pet.name)
                        .font(.headline)

                    Text(stay.pet.breed)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("CHECK IN")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Text(
                        stay.checkInDate,
                        format: .dateTime
                            .month(.abbreviated)
                            .day()
                    )
                    .font(.subheadline)
                    .fontWeight(.medium)
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                VStack(alignment: .trailing, spacing: 3) {
                    Text("CHECK OUT")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Text(
                        stay.checkOutDate,
                        format: .dateTime
                            .month(.abbreviated)
                            .day()
                    )
                    .font(.subheadline)
                    .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
    }
}

private extension CurrentPetStaysView {

    var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "house")
                .font(.largeTitle)

            Text("No Current Stays")
                .font(.headline)

            Text("There are no pets currently staying at the hotel.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 220
        )
    }

    func errorView(
        message: String
    ) -> some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title)

            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 180
        )
    }
}

private extension CurrentPetStaysView {

    func petIcon(
        for pet: Pet
    ) -> String {
        switch pet.species {
        case .dog:
            return "dog"
        case .cat:
            return "cat"
        }
    }

    func speciesTitle(
        for pet: Pet
    ) -> String {
        switch pet.species {
        case .dog:
            return "DOG"
        case .cat:
            return "CAT"
        }
    }
}

#if DEBUG

private final class PreviewPetStayRepository: PetStayRepository {

    var petStays: [PetStay] = []

    func fetchPetStays() throws -> [PetStay] {
        petStays
    }

    func savePetStay(_ petStay: PetStay) throws {
        petStays.append(petStay)
    }

    func deletePetStay(id: UUID) throws {
        petStays.removeAll { $0.id == id }
    }
}

#Preview("Current Pet Stays") {

    let persistenceController = PersistenceController(
        inMemory: true
    )

    let appContainer = AppContainer(
        persistenceController: persistenceController
    )

    CurrentPetStaysView(
        viewModel:
            appContainer.makeCurrentPetStaysViewModel(),
        appContainer: appContainer
    )
}

#endif

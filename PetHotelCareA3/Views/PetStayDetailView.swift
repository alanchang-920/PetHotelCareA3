//
//  PetStayDetailView.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import SwiftUI

struct PetStayDetailView: View {

    @ObservedObject var viewModel: PetStayDetailViewModel

    let petStayID: UUID
    let appContainer: AppContainer

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 20
            ) {
                if viewModel.isLoading {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                } else if let stay = viewModel.petStay {
                    stayContent(stay)
                } else {
                    emptyView
                }
            }
            .padding()
        }
        .navigationTitle("Stay Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadPetStay(id: petStayID)
        }
        .onChange(
            of: viewModel.petStay?.id
        ) { _, _ in
            if let petStay = viewModel.petStay {
                WidgetDataService.shared
                    .updateNextPetName(
                        petStay.pet.name
                    )
            }
        }
    }
}

private extension PetStayDetailView {

    @ViewBuilder
    func stayContent(
        _ stay: PetStay
    ) -> some View {
        petSection(stay)
        staySection(stay)
        feedingSection(stay)
        careNotesSection(stay)
        actionsSection(stay)
    }
}

private extension PetStayDetailView {

    func petSection(
        _ stay: PetStay
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("Pet")
                .font(.headline)

            HStack(spacing: 14) {
                Image(systemName: "pawprint.fill")
                    .font(.title2)
                    .frame(
                        width: 48,
                        height: 48
                    )
                    .background(
                        Color.secondary.opacity(0.12)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text(stay.pet.name)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(
                        "\(stay.pet.species.rawValue.capitalized) • \(stay.pet.breed)"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                Spacer()
            }
        }
    }
}

private extension PetStayDetailView {

    func staySection(
        _ stay: PetStay
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("Stay")
                .font(.headline)

            VStack(spacing: 0) {
                detailRow(
                    title: "Room",
                    value: stay.roomNumber
                )

                Divider()

                detailRow(
                    title: "Check In",
                    value: stay.checkInDate.formatted(
                        date: .abbreviated,
                        time: .omitted
                    )
                )

                Divider()

                detailRow(
                    title: "Check Out",
                    value: stay.checkOutDate.formatted(
                        date: .abbreviated,
                        time: .omitted
                    )
                )
            }
            .padding()
            .background(
                Color(.secondarySystemBackground)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
        }
    }

    func detailRow(
        title: String,
        value: String
    ) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.medium)
        }
        .padding(.vertical, 10)
    }
}

private extension PetStayDetailView {

    func feedingSection(
        _ stay: PetStay
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            Label(
                "Feeding Instructions",
                systemImage: "fork.knife"
            )
            .font(.headline)

            Text(
                stay.feedingInstructions.isEmpty
                    ? "No feeding instructions."
                    : stay.feedingInstructions
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding()
            .background(
                Color(.secondarySystemBackground)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
        }
    }
}

private extension PetStayDetailView {

    func careNotesSection(
        _ stay: PetStay
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            Label(
                "Care Notes",
                systemImage: "note.text"
            )
            .font(.headline)

            Text(
                stay.careNotes.isEmpty
                    ? "No care notes."
                    : stay.careNotes
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding()
            .background(
                Color(.secondarySystemBackground)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
        }
    }
}

private extension PetStayDetailView {

    func actionsSection(
        _ stay: PetStay
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("Care")
                .font(.headline)

            NavigationLink {
                CareTasksView(
                    viewModel: appContainer.makeCareTasksViewModel(),
                    petStayID: stay.id,
                    petName: stay.pet.name
                )
            } label: {
                actionRow(
                    title: "Daily Care Tasks",
                    systemImage: "checklist"
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                MedicationScheduleView(
                    petStayID: stay.id,
                    viewModel:
                        appContainer.makeMedicationScheduleViewModel()
                )
            } label: {
                actionRow(
                    title: "Medication Schedule",
                    systemImage: "pills"
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                CareHistoryView(
                    petStayID: stay.id,
                    viewModel:
                        appContainer.makeCareHistoryViewModel()
                )
            } label: {
                actionRow(
                    title: "Care History",
                    systemImage: "clock.arrow.circlepath"
                )
            }
            .buttonStyle(.plain)
        }
    }

    func actionRow(
        title: String,
        systemImage: String
    ) -> some View {
        HStack {
            Image(systemName: systemImage)
                .frame(width: 28)

            Text(title)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .fontWeight(.medium)
        .padding()
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 14)
        )
    }
}

private extension PetStayDetailView {

    var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()

            Text("Loading stay...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 250
        )
    }

    func errorView(
        message: String
    ) -> some View {
        VStack(spacing: 12) {
            Image(
                systemName: "exclamationmark.triangle"
            )
            .font(.title)

            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 250
        )
    }

    var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "house")
                .font(.title)

            Text("Stay Not Found")
                .font(.headline)

            Text(
                "The selected pet stay could not be found."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 250
        )
    }
}

#if DEBUG

private final class PreviewPetStayDetailRepository: PetStayRepository {

    private var petStays: [PetStay]

    init(
        petStays: [PetStay]
    ) {
        self.petStays = petStays
    }

    func fetchPetStays() throws -> [PetStay] {
        petStays
    }

    func savePetStay(
        _ petStay: PetStay
    ) throws {
        petStays.append(petStay)
    }

    func deletePetStay(
        id: UUID
    ) throws {
        petStays.removeAll {
            $0.id == id
        }
    }
}

#Preview("Pet Stay Detail") {

    let persistenceController = PersistenceController(
        inMemory: true
    )

    let appContainer = AppContainer(
        persistenceController: persistenceController
    )

    let owner = PetOwner(
        name: "Alan Chang",
        phoneNumber: "0412 345 678"
    )

    let pet = Pet(
        name: "Milo",
        species: .dog,
        breed: "Golden Retriever",
        dateOfBirth: Calendar.current.date(
            byAdding: .year,
            value: -3,
            to: Date()
        ) ?? Date(),
        owner: owner
    )

    let petStay = PetStay(
        pet: pet,
        roomNumber: "101",
        checkInDate: Date(),
        checkOutDate: Calendar.current.date(
            byAdding: .day,
            value: 3,
            to: Date()
        ) ?? Date(),
        feedingInstructions: "1 cup of dry food twice daily",
        careNotes: "Friendly and enjoys walks"
    )

    let repository = PreviewPetStayDetailRepository(
        petStays: [petStay]
    )

    let useCase = GetPetStayDetailUseCase(
        petStayRepository: repository
    )

    let viewModel = PetStayDetailViewModel(
        getPetStayDetailUseCase: useCase
    )

    NavigationStack {
        PetStayDetailView(
            viewModel: viewModel,
            petStayID: petStay.id,
            appContainer: appContainer
        )
    }
}

#endif

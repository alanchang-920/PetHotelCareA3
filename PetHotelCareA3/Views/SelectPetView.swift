//
//  SelectPetView.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/7.
//

import SwiftUI

struct SelectPetView: View {

    @ObservedObject var viewModel: PetSelectionViewModel
    let appContainer: AppContainer

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                petsSection
            }
            .padding()
        }
        .navigationTitle("Select Pet")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                NavigationLink {
                    AddPetView(
                        viewModel: viewModel
                    )
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.loadPets()
        }
    }
}

private extension SelectPetView {

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Select a Pet")
                .font(.title2)
                .fontWeight(.bold)

            Text("Choose a pet to create a new stay.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

private extension SelectPetView {

    @ViewBuilder
    var petsSection: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(
                    maxWidth: .infinity,
                    minHeight: 200
                )
        } else if let errorMessage = viewModel.errorMessage {
            errorView(
                message: errorMessage
            )
        } else if viewModel.pets.isEmpty {
            emptyState
        } else {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.pets) { pet in
                    NavigationLink {
                        CreatePetStayView(
                            pet: pet,
                            viewModel:
                                appContainer.makeCreatePetStayViewModel()
                        )
                    } label: {
                        petCard(pet)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private extension SelectPetView {

    func petCard(
        _ pet: Pet
    ) -> some View {
        HStack(spacing: 14) {
            Image(
                systemName: petIcon(
                    for: pet
                )
            )
            .font(.title2)
            .frame(
                width: 48,
                height: 48
            )
            .background(
                Color(.tertiarySystemBackground)
            )
            .clipShape(Circle())

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(pet.name)
                    .font(.headline)

                Text(pet.breed)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(
                    pet.species.rawValue.capitalized
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Image(
                systemName: "chevron.right"
            )
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18
            )
        )
    }
}

private extension SelectPetView {

    var emptyState: some View {
        VStack(spacing: 14) {
            Image(
                systemName: "pawprint"
            )
            .font(.largeTitle)

            Text("No Pets Yet")
                .font(.headline)

            Text(
                "Add a pet before creating a new stay."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)

            NavigationLink {
                AddPetView(
                    viewModel: viewModel
                )
            } label: {
                Label(
                    "Add New Pet",
                    systemImage: "plus"
                )
                .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 4)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 260
        )
    }

    func errorView(
        message: String
    ) -> some View {
        VStack(spacing: 10) {
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
            minHeight: 200
        )
    }
}

private extension SelectPetView {

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
}

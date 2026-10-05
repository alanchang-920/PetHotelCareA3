//
//  CreatePetStayView.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import SwiftUI

struct CreatePetStayView: View {

    let pet: Pet

    @ObservedObject var viewModel: CreatePetStayViewModel

    var body: some View {
        Form {

            petSection

            staySection

            careSection

            if let errorMessage = viewModel.errorMessage {
                errorSection(message: errorMessage)
            }

            if viewModel.createdPetStay != nil {
                successSection
            }

            createSection
        }
        .navigationTitle("Create Pet Stay")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension CreatePetStayView {

    var petSection: some View {
        Section("Pet") {

            HStack {
                Text("Name")

                Spacer()

                Text(pet.name)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Species")

                Spacer()

                Text(pet.species.rawValue.capitalized)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Breed")

                Spacer()

                Text(pet.breed)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private extension CreatePetStayView {

    var staySection: some View {
        Section("Stay Details") {

            TextField(
                "Room Number",
                text: $viewModel.roomNumber
            )

            DatePicker(
                "Check In",
                selection: $viewModel.checkInDate,
                displayedComponents: [.date]
            )

            DatePicker(
                "Check Out",
                selection: $viewModel.checkOutDate,
                displayedComponents: [.date]
            )
        }
    }
}

private extension CreatePetStayView {

    var careSection: some View {
        Section("Care Information") {

            TextField(
                "Feeding Instructions",
                text: $viewModel.feedingInstructions,
                axis: .vertical
            )
            .lineLimit(2...5)

            TextField(
                "Care Notes",
                text: $viewModel.careNotes,
                axis: .vertical
            )
            .lineLimit(2...5)
        }
    }
}

private extension CreatePetStayView {

    func errorSection(
        message: String
    ) -> some View {

        Section {
            Label(
                message,
                systemImage: "exclamationmark.triangle.fill"
            )
            .foregroundStyle(.red)
        }
    }
}

private extension CreatePetStayView {

    var successSection: some View {
        Section {

            Label(
                "Pet stay created successfully.",
                systemImage: "checkmark.circle.fill"
            )
            .foregroundStyle(.green)
        }
    }
}

private extension CreatePetStayView {

    var createSection: some View {
        Section {

            Button {
                viewModel.createPetStay(for: pet)
            } label: {

                HStack {

                    Spacer()

                    if viewModel.isSaving {

                        ProgressView()

                    } else {

                        Text("Create Pet Stay")
                            .fontWeight(.semibold)
                    }

                    Spacer()
                }
            }
            .disabled(
                viewModel.isSaving ||
                viewModel.roomNumber
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty
            )
        }
    }
}

#Preview("Create Pet Stay") {
    
    let owner = PetOwner(
        name: "Alan",
        phoneNumber: "0400 123 456"
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
    
    let repository = PreviewPetStayRepository()
    
    let useCase = CreatePetStayUseCase(
        petStayRepository: repository
    )
    
    let viewModel = CreatePetStayViewModel(
        createPetStayUseCase: useCase
    )
    
    NavigationStack {
        CreatePetStayView(
            pet: pet,
            viewModel: viewModel
        )
    }
}

private final class PreviewPetStayRepository: PetStayRepository {

    private var petStays: [PetStay] = []

    func fetchPetStays() throws -> [PetStay] {
        petStays
    }

    func savePetStay(_ petStay: PetStay) throws {
        petStays.append(petStay)
    }

    func deletePetStay(id: UUID) throws {
        petStays.removeAll {
            $0.id == id
        }
    }
}

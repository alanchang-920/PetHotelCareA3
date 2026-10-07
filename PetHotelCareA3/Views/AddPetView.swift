//
//  AddPetView.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/7.
//

import SwiftUI

struct AddPetView: View {

    @ObservedObject var viewModel: PetSelectionViewModel

    @Environment(\.dismiss)
    private var dismiss

    @State private var name = ""
    @State private var species: PetSpecies = .dog
    @State private var breed = ""
    @State private var dateOfBirth = Date()
    @State private var ownerName = ""
    @State private var ownerPhoneNumber = ""

    var body: some View {
        Form {
            petSection
            ownerSection

            if let errorMessage = viewModel.errorMessage {
                errorSection(
                    message: errorMessage
                )
            }

            createSection
        }
        .navigationTitle("Add Pet")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.createdPet) { _, newPet in
            if newPet != nil {
                dismiss()
            }
        }
    }
}

private extension AddPetView {

    var petSection: some View {
        Section("Pet Information") {
            TextField(
                "Pet Name",
                text: $name
            )

            Picker(
                "Species",
                selection: $species
            ) {
                Text("Dog")
                    .tag(PetSpecies.dog)

                Text("Cat")
                    .tag(PetSpecies.cat)
            }

            TextField(
                "Breed",
                text: $breed
            )

            DatePicker(
                "Date of Birth",
                selection: $dateOfBirth,
                in: ...Date(),
                displayedComponents: [.date]
            )
        }
    }
}

private extension AddPetView {

    var ownerSection: some View {
        Section("Owner Information") {
            TextField(
                "Owner Name",
                text: $ownerName
            )

            TextField(
                "Phone Number",
                text: $ownerPhoneNumber
            )
            .keyboardType(.phonePad)
        }
    }
}

private extension AddPetView {

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

private extension AddPetView {

    var createSection: some View {
        Section {
            Button {
                createPet()
            } label: {
                HStack {
                    Spacer()

                    if viewModel.isSaving {
                        ProgressView()
                    } else {
                        Text("Add Pet")
                            .fontWeight(.semibold)
                    }

                    Spacer()
                }
            }
            .disabled(
                viewModel.isSaving ||
                name.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty ||
                breed.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty ||
                ownerName.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty ||
                ownerPhoneNumber.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty
            )
        }
    }

    func createPet() {
        viewModel.createPet(
            name: name.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            species: species,
            breed: breed.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            dateOfBirth: dateOfBirth,
            ownerName: ownerName.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            ownerPhoneNumber:
                ownerPhoneNumber.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
        )
    }
}

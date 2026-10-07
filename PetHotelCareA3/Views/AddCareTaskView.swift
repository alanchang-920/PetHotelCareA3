//
//  AddCareTaskView.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/7.
//

import SwiftUI

struct AddCareTaskView: View {

    @ObservedObject var viewModel: CareTasksViewModel

    let petStayID: UUID
    let petName: String

    @Environment(\.dismiss) private var dismiss

    @State private var selectedType: CareTaskType = .feeding
    @State private var scheduledTime = Date()
    @State private var instructions = ""

    var body: some View {
        Form {
            taskTypeSection
            scheduleSection
            instructionsSection
            addTaskSection
        }
        .navigationTitle("Add Care Task")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension AddCareTaskView {

    var taskTypeSection: some View {
        Section("Task Type") {
            Picker(
                "Type",
                selection: $selectedType
            ) {
                Text("Feeding")
                    .tag(CareTaskType.feeding)

                Text("Walk")
                    .tag(CareTaskType.walk)

                Text("Medication")
                    .tag(CareTaskType.medication)
            }
        }
    }
}

private extension AddCareTaskView {

    var scheduleSection: some View {
        Section("Schedule") {
            DatePicker(
                "Scheduled Time",
                selection: $scheduledTime,
                displayedComponents: [
                    .date,
                    .hourAndMinute
                ]
            )
        }
    }
}

private extension AddCareTaskView {

    var instructionsSection: some View {
        Section("Instructions") {
            TextField(
                "Enter task instructions",
                text: $instructions,
                axis: .vertical
            )
            .lineLimit(3...6)
        }
    }
}

private extension AddCareTaskView {

    var addTaskSection: some View {
        Section {
            Button {
                addTask()
            } label: {
                HStack {
                    Spacer()

                    Text("Add Task")
                        .fontWeight(.semibold)

                    Spacer()
                }
            }
        }
    }

    func addTask() {
        viewModel.createTask(
            petStayID: petStayID,
            petName: petName,
            type: selectedType,
            scheduledTime: scheduledTime,
            instructions: instructions
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
        )

        dismiss()
    }
}

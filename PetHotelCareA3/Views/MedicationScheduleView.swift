//
//  MedicationScheduleView.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import SwiftUI

struct MedicationScheduleView: View {

    let petStayID: UUID

    @ObservedObject var viewModel: MedicationScheduleViewModel

    @State private var showingAddMedication = false

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 20
            ) {

                headerSection

                contentSection
            }
            .padding()
        }
        .navigationTitle("Medication Schedule")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                Button {
                    showingAddMedication = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(
            isPresented: $showingAddMedication
        ) {
            addMedicationSheet
        }
        .onAppear {
            viewModel.loadSchedules(
                for: petStayID
            )
        }
    }
}

private extension MedicationScheduleView {

    var headerSection: some View {
        HStack {

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text("Medication")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Medication schedules for this stay")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 2) {
                Text("\(viewModel.schedules.count)")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Schedules")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Color(.secondarySystemBackground)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14
                )
            )
        }
    }

    @ViewBuilder
    var contentSection: some View {

        if viewModel.isLoading {
            loadingView

        } else if let errorMessage =
                    viewModel.errorMessage {

            errorView(
                message: errorMessage
            )

        } else if viewModel.schedules.isEmpty {

            emptyState

        } else {

            schedulesSection
        }
    }

    var schedulesSection: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            Text("Schedules")
                .font(.headline)

            ForEach(viewModel.schedules) { schedule in

                medicationCard(
                    schedule
                )
                .contextMenu {
                    Button(
                        role: .destructive
                    ) {
                        viewModel.deleteSchedule(
                            schedule
                        )
                    } label: {
                        Label(
                            "Delete",
                            systemImage: "trash"
                        )
                    }
                }
            }
        }
    }

    func medicationCard(
        _ schedule: MedicationSchedule
    ) -> some View {

        HStack(
            alignment: .center,
            spacing: 14
        ) {

            ZStack {
                Circle()
                    .fill(
                        Color(.systemGray5)
                    )
                    .frame(
                        width: 42,
                        height: 42
                    )

                Image(
                    systemName: "pills"
                )
                .font(.headline)
            }

            VStack(
                alignment: .leading,
                spacing: 5
            ) {

                Text(
                    schedule.medicationName
                )
                .font(.headline)

                Text(
                    schedule.dosage
                )
                .font(.subheadline)
                .foregroundStyle(
                    .secondary
                )

                Label(
                    "Minimum interval: \(formattedInterval(schedule.minimumIntervalHours))",
                    systemImage: "clock.arrow.circlepath"
                )
                .font(.caption)
                .foregroundStyle(
                    .secondary
                )
            }

            Spacer()

            VStack(
                alignment: .trailing,
                spacing: 4
            ) {

                Text(
                    schedule.scheduledTime,
                    format: .dateTime
                        .hour()
                        .minute()
                )
                .font(.subheadline)
                .fontWeight(.semibold)

                Text("Scheduled")
                    .font(.caption2)
                    .foregroundStyle(
                        .secondary
                    )
            }
        }
        .padding()
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
    }

    var loadingView: some View {
        VStack(spacing: 12) {

            ProgressView()

            Text(
                "Loading medication schedules..."
            )
            .font(.subheadline)
            .foregroundStyle(
                .secondary
            )
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 180
        )
    }

    var emptyState: some View {
        VStack(spacing: 12) {

            Image(
                systemName: "pills"
            )
            .font(.largeTitle)

            Text(
                "No Medication Scheduled"
            )
            .font(.headline)

            Text(
                "There are no medication schedules for this stay."
            )
            .font(.subheadline)
            .foregroundStyle(
                .secondary
            )
            .multilineTextAlignment(
                .center
            )

            Button {
                showingAddMedication = true
            } label: {
                Label(
                    "Add Medication",
                    systemImage: "plus"
                )
            }
            .buttonStyle(
                .borderedProminent
            )
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 220
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
                .multilineTextAlignment(
                    .center
                )

            Button("Try Again") {
                viewModel.loadSchedules(
                    for: petStayID
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 180
        )
    }

    func formattedInterval(
        _ hours: Double
    ) -> String {

        if hours.rounded() == hours {
            return "\(Int(hours)) hours"
        }

        return "\(hours) hours"
    }
}

private extension MedicationScheduleView {

    var addMedicationSheet: some View {

        AddMedicationScheduleView(
            petStayID: petStayID,
            viewModel: viewModel,
            isPresented:
                $showingAddMedication
        )
    }
}

private struct AddMedicationScheduleView: View {

    let petStayID: UUID

    @ObservedObject var viewModel:
        MedicationScheduleViewModel

    @Binding var isPresented: Bool

    @State private var medicationName = ""

    @State private var dosage = ""

    @State private var scheduledTime =
        Date()

    @State private var minimumIntervalHours =
        12.0

    var body: some View {

        NavigationStack {

            Form {

                Section("Medication") {

                    TextField(
                        "Medication Name",
                        text: $medicationName
                    )

                    TextField(
                        "Dosage",
                        text: $dosage
                    )
                }

                Section("Schedule") {

                    DatePicker(
                        "Time",
                        selection: $scheduledTime,
                        displayedComponents: [
                            .hourAndMinute
                        ]
                    )

                    Stepper(
                        value:
                            $minimumIntervalHours,
                        in: 1...48,
                        step: 1
                    ) {
                        HStack {

                            Text(
                                "Minimum Interval"
                            )

                            Spacer()

                            Text(
                                "\(Int(minimumIntervalHours)) hr"
                            )
                            .foregroundStyle(
                                .secondary
                            )
                        }
                    }
                }
            }
            .navigationTitle(
                "Add Medication"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement:
                        .cancellationAction
                ) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }

                ToolbarItem(
                    placement:
                        .confirmationAction
                ) {
                    Button("Save") {

                        viewModel.createSchedule(
                            petStayID:
                                petStayID,
                            medicationName:
                                medicationName,
                            dosage:
                                dosage,
                            scheduledTime:
                                scheduledTime,
                            minimumIntervalHours:
                                minimumIntervalHours
                        )

                        if viewModel.errorMessage == nil {
                            isPresented = false
                        }
                    }
                    .disabled(
                        medicationName
                            .trimmingCharacters(
                                in:
                                    .whitespacesAndNewlines
                            )
                            .isEmpty ||
                        dosage
                            .trimmingCharacters(
                                in:
                                    .whitespacesAndNewlines
                            )
                            .isEmpty
                    )
                }
            }
        }
    }
}

#Preview("Medication Schedule") {

    let petStayID = UUID()

    let calendar = Calendar.current

    let carprofenTime =
        calendar.date(
            bySettingHour: 14,
            minute: 0,
            second: 0,
            of: Date()
        ) ?? Date()

    let antibioticTime =
        calendar.date(
            bySettingHour: 20,
            minute: 0,
            second: 0,
            of: Date()
        ) ?? Date()

    let schedules = [

        MedicationSchedule(
            petStayID: petStayID,
            medicationName: "Carprofen",
            dosage: "25 mg",
            scheduledTime:
                carprofenTime,
            minimumIntervalHours: 12
        ),

        MedicationSchedule(
            petStayID: petStayID,
            medicationName: "Antibiotic",
            dosage: "1 tablet",
            scheduledTime:
                antibioticTime,
            minimumIntervalHours: 8
        )
    ]

    let repository =
        PreviewMedicationScheduleRepository(
            schedules: schedules
        )

    let useCase =
        ManageMedicationSchedulesUseCase(
            medicationScheduleRepository:
                repository
        )

    let viewModel =
        MedicationScheduleViewModel(
            manageMedicationSchedulesUseCase:
                useCase
        )

    NavigationStack {
        MedicationScheduleView(
            petStayID: petStayID,
            viewModel: viewModel
        )
    }
}

private final class
PreviewMedicationScheduleRepository:
    MedicationScheduleRepository {

    private var schedules:
        [MedicationSchedule]

    init(
        schedules: [MedicationSchedule]
    ) {
        self.schedules = schedules
    }

    func fetchMedicationSchedules()
        throws -> [MedicationSchedule] {

        schedules
    }

    func saveMedicationSchedule(
        _ schedule: MedicationSchedule
    ) throws {

        if let index =
            schedules.firstIndex(
                where: {
                    $0.id == schedule.id
                }
            ) {

            schedules[index] = schedule

        } else {

            schedules.append(
                schedule
            )
        }
    }

    func deleteMedicationSchedule(
        id: UUID
    ) throws {

        schedules.removeAll {
            $0.id == id
        }
    }
}

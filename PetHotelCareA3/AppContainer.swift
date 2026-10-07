//
//  AppContainer.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/7.
//

import Foundation
import CoreData

@MainActor
final class AppContainer {

    let persistenceController: PersistenceController

    let petStayRepository: PetStayRepository
    let petRepository: PetRepository
    let careTaskRepository: CareTaskRepository
    let careActivityRecordRepository: CareActivityRecordRepository
    let medicationScheduleRepository: MedicationScheduleRepository

    let completeCareTaskUseCase: CompleteCareTaskUseCase
    let createPetStayUseCase: CreatePetStayUseCase
    let getCareHistoryUseCase: GetCareHistoryUseCase
    let getCurrentPetStaysUseCase: GetCurrentPetStaysUseCase
    let getPetStayDetailUseCase: GetPetStayDetailUseCase
    let getTodaysCareTasksUseCase: GetTodaysCareTasksUseCase
    let manageCareTasksUseCase: ManageCareTasksUseCase
    let manageMedicationSchedulesUseCase: ManageMedicationSchedulesUseCase
    let managePetsUseCase: ManagePetsUseCase

    init(
        persistenceController: PersistenceController
    ) {
        self.persistenceController = persistenceController

        let context = persistenceController.container.viewContext

        let petStayRepository = CoreDataPetStayRepository(
            context: context
        )

        let petRepository = CoreDataPetRepository(
            context: context
        )

        let careTaskRepository = CoreDataCareTaskRepository(
            context: context
        )

        let careActivityRecordRepository =
            CoreDataCareActivityRecordRepository(
                context: context
            )

        let medicationScheduleRepository =
            CoreDataMedicationScheduleRepository(
                context: context
            )

        self.petStayRepository = petStayRepository
        self.petRepository = petRepository
        self.careTaskRepository = careTaskRepository
        self.careActivityRecordRepository =
            careActivityRecordRepository
        self.medicationScheduleRepository =
            medicationScheduleRepository

        self.completeCareTaskUseCase = CompleteCareTaskUseCase(
            careTaskRepository: careTaskRepository,
            careActivityRecordRepository:
                careActivityRecordRepository
        )

        self.createPetStayUseCase = CreatePetStayUseCase(
            petStayRepository: petStayRepository
        )

        self.getCareHistoryUseCase = GetCareHistoryUseCase(
            careActivityRecordRepository:
                careActivityRecordRepository
        )

        self.getCurrentPetStaysUseCase =
            GetCurrentPetStaysUseCase(
                petStayRepository: petStayRepository
            )

        self.getPetStayDetailUseCase =
            GetPetStayDetailUseCase(
                petStayRepository: petStayRepository
            )

        self.getTodaysCareTasksUseCase =
            GetTodaysCareTasksUseCase(
                careTaskRepository: careTaskRepository
            )

        self.manageCareTasksUseCase =
            ManageCareTasksUseCase(
                careTaskRepository: careTaskRepository
            )

        self.manageMedicationSchedulesUseCase =
            ManageMedicationSchedulesUseCase(
                medicationScheduleRepository:
                    medicationScheduleRepository
            )
        
        self.managePetsUseCase = ManagePetsUseCase(
            petRepository: petRepository
        )
    }

    func makeTodayCareDashboardViewModel()
        -> TodayCareDashboardViewModel {

        TodayCareDashboardViewModel(
            getTodaysCareTasksUseCase:
                getTodaysCareTasksUseCase
        )
    }

    func makeCurrentPetStaysViewModel()
        -> CurrentPetStaysViewModel {

        CurrentPetStaysViewModel(
            getCurrentPetStaysUseCase:
                getCurrentPetStaysUseCase
        )
    }

    func makeCreatePetStayViewModel()
        -> CreatePetStayViewModel {

        CreatePetStayViewModel(
            createPetStayUseCase:
                createPetStayUseCase
        )
    }

    func makePetStayDetailViewModel()
        -> PetStayDetailViewModel {

        PetStayDetailViewModel(
            getPetStayDetailUseCase:
                getPetStayDetailUseCase
        )
    }

    func makeCareTasksViewModel()
        -> CareTasksViewModel {

        CareTasksViewModel(
            manageCareTasksUseCase:
                manageCareTasksUseCase,
            completeCareTaskUseCase:
                completeCareTaskUseCase
        )
    }

    func makeMedicationScheduleViewModel()
        -> MedicationScheduleViewModel {

        MedicationScheduleViewModel(
            manageMedicationSchedulesUseCase:
                manageMedicationSchedulesUseCase
        )
    }

    func makeCareHistoryViewModel()
        -> CareHistoryViewModel {

        CareHistoryViewModel(
            getCareHistoryUseCase:
                getCareHistoryUseCase
        )
    }
    
    func makePetSelectionViewModel()
        -> PetSelectionViewModel {

        PetSelectionViewModel(
            managePetsUseCase: managePetsUseCase
        )
    }
}

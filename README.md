# Pet Hotel Care

Pet Hotel Care is an iOS application designed to support pet hotel staff in managing pet stays and daily care activities.

The application allows staff to review current guests, manage scheduled care tasks, maintain medication schedules, record completed activities, and quickly access important care information.

The project was developed for UTS Assessment 3 using SwiftUI, Core Data, a domain-centred architecture, WidgetKit, and a Notification Content Extension.

## Domain Context

Pet hotel staff may be responsible for multiple pets with different feeding instructions, care notes, medication requirements, and scheduled activities.

Pet Hotel Care provides a centralised workflow for managing this information and helps staff reduce the risk of missed or duplicated care activities.

The main domain concepts are:

- Pet
- Pet Owner
- Pet Stay
- Care Task
- Medication Schedule
- Care Activity Record
- Staff Member

## Main Features

Pet Hotel Care allows staff to:

- View current pet stays
- Create new pet stays
- Add and select pets
- View pet and stay details
- Review daily care tasks
- Create new care tasks
- Mark care tasks as completed
- Review completed care history
- Create and manage medication schedules
- Receive scheduled care task notifications
- View today's care workload from a Home Screen widget
- Access Today's Care and Current Stays through Home Screen Quick Actions

## Architecture

The application follows a layered, domain-centred architecture:

```text
SwiftUI Views
      ↓
ViewModels
      ↓
Use Cases
      ↓
Repository Protocols
      ↓
Core Data Repositories
      ↓
Core Data
```

### Views and ViewModels

SwiftUI Views provide the user interface for pet hotel staff.

ViewModels manage presentation state and communicate with the domain layer. Views do not directly access Core Data.

The application contains functional screens including:

- Today's Care
- Current Stays
- Pet Stay Detail
- Daily Care Tasks
- Add Care Task
- Medication Schedule
- Care History
- Create Pet Stay
- Select Pet
- Add Pet

### Use Cases

Business operations are encapsulated in Use Cases.

Examples include:

- `CreatePetStayUseCase`
- `CompleteCareTaskUseCase`
- `GetCurrentPetStaysUseCase`
- `GetPetStayDetailUseCase`
- `GetTodaysCareTasksUseCase`
- `GetCareHistoryUseCase`
- `ManageCareTasksUseCase`
- `ManageMedicationSchedulesUseCase`
- `ManagePetsUseCase`

The domain layer also enforces business rules. Examples include:

- A pet stay must have a check-out date later than its check-in date.
- A completed care task cannot be completed again.
- A medication schedule must have a minimum interval greater than zero.

Typed domain errors are used to represent invalid business operations.

### Repository Layer

Repository protocols separate domain logic from persistence.

Use Cases communicate with repository protocols rather than directly accessing Core Data. Core Data repository implementations are responsible for storing and retrieving persistent data.

This separation also allows Use Cases to be unit tested with mock repositories.

## Database

Pet Hotel Care uses Core Data for persistent storage.

Core Data is suitable for the application because the pet hotel domain contains structured and related information that must remain available between app launches.

Persistent information includes:

- Pets and owners
- Pet stays
- Care tasks
- Medication schedules
- Care activity records
- Staff information

The repository layer provides the boundary between Core Data and the domain layer.

Domain-specific retrieval is also supported, such as retrieving current pet stays and care tasks associated with a particular stay.

## System Extensions

The project includes two iOS system extensions.

### WidgetKit Widget Extension

The WidgetKit extension allows staff to view today's care workload directly from the Home Screen without opening the main application.

The widget displays information including:

- Pending care task count
- Next pet requiring care
- Next care task type
- Scheduled care time

Two widget families are supported:

- `systemSmall`
- `systemMedium`

The main application and WidgetKit extension share care information using an App Group.

App Group identifier:

```text
group.student.uts.edu.au.PetHotelCareA3
```

When relevant care task information changes, the application updates the shared widget data and requests a WidgetKit timeline reload.

### Notification Content Extension

The Notification Content Extension provides a customised interface when a care task notification is expanded.

Care task notifications use the category:

```text
CARE_TASK
```

The custom notification interface displays:

- Pet name
- Care task type
- Care task notification message

This allows staff to understand the required care activity directly from the notification.

## Additional iOS Integration

### Local Notifications

Local notifications are scheduled for future care tasks.

The notification contains relevant pet and task information and is connected to the Notification Content Extension.

### Home Screen Quick Actions

The application provides Home Screen Quick Actions for:

- Today's Care
- Current Stays

These shortcuts allow staff to enter common workflows directly from the Home Screen.

## Testing

The project contains unit tests for the domain and repository layers.

Use Case tests use mock repository implementations so business logic can be tested independently from the real Core Data stack.

The tests cover:

- Successful business operations
- Business rule validation
- Boundary cases
- Typed domain errors
- Repository persistence
- Filtering and sorting behaviour

Examples include:

- Creating a pet stay with valid dates
- Rejecting invalid stay dates
- Preventing an already completed care task from being completed again
- Handling a missing care task
- Rejecting an invalid medication interval
- Filtering current pet stays
- Sorting care history
- Core Data save, update, fetch, and delete operations

The final test run contains:

```text
35 tests
14 test suites
35 passed
0 failed
```

## Project Structure

```text
PetHotelCareA3
├── Data
│   ├── Persistence
│   └── Repositories
├── Domain
│   ├── Models
│   ├── Repositories
│   ├── UseCases
│   └── Errors
├── Services
├── ViewModels
├── Views
├── PetHotelCareWidget
├── PetHotelCareNotificationContent
└── PetHotelCareA3Tests
```

The structure separates user interface, business logic, and persistence responsibilities.

## App Group

The main application and WidgetKit extension use:

```text
group.student.uts.edu.au.PetHotelCareA3
```

The App Group is used to share the care task information required by the Home Screen widget.

## Setup

1. Clone or download this repository.
2. Open `PetHotelCareA3.xcodeproj` in Xcode.
3. Select the `PetHotelCareA3` scheme.
4. Select an iOS Simulator.
5. Build and run the application.
6. Allow notification permission when requested.
7. Create or select a pet stay.
8. Add care tasks to test the daily care workflow.
9. Add the Pet Hotel Care widget to the Home Screen to test WidgetKit integration.
10. Create a future care task to test local notifications.
11. Expand a care task notification to test the Notification Content Extension.
12. Long-press the app icon to test Home Screen Quick Actions.

For WidgetKit integration, ensure the following App Group is configured for both the main application and Widget Extension:

```text
group.student.uts.edu.au.PetHotelCareA3
```

## Technologies

- Swift
- SwiftUI
- Core Data
- WidgetKit
- UserNotifications
- Notification Content Extension
- App Groups
- Swift Testing
- MVVM
- Repository Pattern
- Domain Use Cases

## Version Control

Git is used for version control throughout development.

The repository uses conventional commit prefixes where appropriate, including:

```text
feat:
fix:
test:
docs:
```

Major features were developed incrementally, including the Core Data persistence layer, domain Use Cases, SwiftUI workflows, WidgetKit integration, local notifications, Notification Content Extension, Quick Actions, and domain validation.

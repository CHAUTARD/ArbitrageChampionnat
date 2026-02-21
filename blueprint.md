## Application Title: Tournament Score Tracker

### Overview

This is a Flutter application designed to keep track of match scores for a tournament. It allows users to view a list of matches and add new ones. The application uses a local database (Drift) for offline data persistence and features a clean, modern interface with both light and dark modes.

### Key Features

*   **Offline First:** All match data is stored locally on the device, allowing the app to be fully functional without an internet connection.
*   **Match List:** Displays a list of all tournament matches from the local database.
*   **Add Match:** A dedicated screen to add new matches with player names and scores.
*   **Theme Toggle:** Users can switch between light, dark, and system default themes.
*   **Scalable Architecture:** The project is structured using a clean, layered architecture to separate concerns and improve maintainability.

### Project Structure

*   `lib/`
    *   `main.dart`: The main entry point of the application, responsible for setting up providers and the root widget.
    *   `src/`
        *   `core/`
            *   `data/database.dart`: Defines the local database structure using Drift.
            *   `theme/theme_provider.dart`: Manages the application's theme state (light/dark mode).
        *   `features/`
            *   `home/`
                *   `home_screen.dart`: The main screen that displays the list of matches.
                *   `add_match_screen.dart`: The screen for adding a new match.
            *   `match_management/`
                *   `application/match_service.dart`: The business logic layer, responsible for orchestrating data operations.
                *   `data/repositories/drift_repository.dart`: The data access layer, responsible for all interactions with the local Drift database.
                *   `domain/models/match.dart`: The data model for a match.
        *   `widgets/`
            *   `match_card.dart`: A reusable widget to display a single match.
            *   `theme_toggle_button.dart`: A button for switching the app's theme.

### Architecture

The application follows a layered architecture to ensure a clean separation of concerns:

*   **Presentation Layer (`features/home`, `widgets`):** The UI part of the application, composed of widgets, screens, and UI-specific state management.
*   **Application Layer (`features/match_management/application`):** Contains the core business logic. The `MatchService` coordinates with the data layer.
*   **Data Layer (`features/match_management/data`, `core/data`):** Responsible for data persistence. The `DriftRepository` abstracts away the specifics of the local database, providing a clean API for the application layer.
*   **Domain Layer (`features/match_management/domain`):** Contains the core data structures (models) of the application, such as the `Match` class.

**State Management:**

The project uses **flutter_riverpod** for dependency injection and state management, allowing for a decoupled architecture.

**Navigation:**

Navigation is handled by Flutter's built-in `Navigator` for simplicity.

### Development Plan

**Phase 1: Architectural Refactoring (Completed)**

*   **Separation of Concerns:** The initial code was refactored to separate business logic from the UI and data persistence layers.
*   **Created `FirestoreRepository`:** The logic for interacting with Firebase Firestore was moved from the UI and encapsulated within a dedicated `FirestoreRepository`.
*   **Created `MatchService`:** A `MatchService` was introduced in the application layer to mediate between the UI and the repository, housing the core business logic.
*   **Integrated Riverpod:** `flutter_riverpod` was added to the project to provide the `MatchService` and `FirestoreRepository` to the UI layer through dependency injection.

**Phase 2: Local Database Migration (Completed)**

*   **Replaced Firebase with Drift:** The application was migrated from Firebase Firestore to a local database solution using the Drift package. This enables full offline functionality.
*   **Added Dependencies:** `drift`, `sqlite3_flutter_libs`, and `path_provider` were added to manage the local database.
*   **Created `DriftRepository`:** A new repository was implemented to handle all CRUD (Create, Read, Update, Delete) operations with the Drift database.
*   **Updated Service Layer:** The `MatchService` and its providers were updated to use the new `DriftRepository`.
*   **Removed Firebase:** All Firebase-related dependencies (`cloud_firestore`, `firebase_core`) and initialization code were removed.
*   **Simplified Navigation:** The `go_router` package was removed, and navigation was simplified to use the built-in `Navigator`.

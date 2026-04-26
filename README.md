# N-Queens

A game to solve the N-Queens problem: place N queens on an N×N board so that no two queens threaten each other.

<img src="Demo/demo.gif" width="320" alt="Demo" />

## Architecture

The project is a Swift Package (`N-QueensKit`) structured around **Clean Architecture** principles with **MVVM** in the presentation layer. 

It is split into four modules with explicit dependency rules, plus two test targets.

```
┌─────────────────────────────────────────────┐
│                Presentation                 │
│  (Views, ViewModels, GameFlow, Navigation)  │
└──────────────────────┬──────────────────────┘
                       │ depends on
┌──────────────────────▼──────────────────────┐
│                    Domain                   │
│  (Models, Protocols, Game Logic, Managers)  │
└──────────────────────▲──────────────────────┘
                       │ depends on
┌──────────────────────┴──────────────────────┐
│                Infrastructure               │
│  (Concrete repository implementations)     │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│                    Mocks                    │
│  (Test doubles for Domain protocols)        │
└─────────────────────────────────────────────┘
```

### Domain

The innermost layer. Contains pure Swift — no framework imports beyond Foundation.

- **Models** — `GameState`, `WonGameInfo`, `Position`, `Cell`
- **Managers**
    - `GameModel` game rules
    - `ConflictingPositionsManager` queens conflict detection
    - `BoardBuilder` maps `GameState` to a 2D `Cell` grid
    - `TimeManagerProtocol` abstraction in order to control time during tests.
- **Repositories** 
    - `WonGamesRepositoryProtocol` defines the persistence contract as an `async throws` interface

Nothing in Domain knows about UIKit, SwiftUI, UserDefaults, or any other framework.

### Infrastructure

Concrete implementations of Domain protocols, wired to platform APIs.

- **`WonGamesRepository`** — `actor` that serialises `[WonGameInfo]` to JSON and persists it in `UserDefaults`. Takes an injectable `UserDefaults` instance so it can be pointed at a different suite in tests or previews.
- **`TimeManager`** — `@MainActor` class that drives a `Task`-based timer, publishing elapsed time via a callback.

### Presentation

SwiftUI views and `@Observable` view models. Depends only on Domain — never on Infrastructure directly.

#### MVVM

Each screen has a paired view model:

| Screen | View | ViewModel |
|---|---|---|
| Setup | `GameSetupView` | `GameSetupViewModel` |
| Game | `GameView` | `GameViewModel` |
| Best Times | `BestTimesView` | `BestTimesViewModel` |

View models are `@Observable` and expose only what views need to read (`private(set)`). They receive their dependencies through initialiser injection and communicate back to the coordinator via action closures rather than delegates or notifications.

#### Navigation

`GameFlow` is the single entry point for the SwiftUI navigation tree. It owns a `NavigationStack` driven by a `[Route]` state array, where `Route` is a `Hashable` enum:

```swift
enum Route: Hashable {
    case game(boadSize: Int)
    case bestTimes
}
```

`GameFlow` creates view models for each destination inline and passes the appropriate closures (e.g. `exitGame`) so child screens never push or pop the stack themselves — they simply call a closure and the coordinator decides what to do with the navigation state.

#### Dependency Injection

`GameFlow` receives its external dependencies through a `Dependencies` typealias:

```swift
public typealias Dependencies = GameViewModelFactory & BestTimesViewModelFactory
```

The host app provides a concrete object conforming to both factory protocols. This keeps `GameFlow` decoupled from `Infrastructure` — it never imports or instantiates repositories directly. View models receive repository and manager dependencies through their own initialisers, injected by the factory.

### Mocks

Lightweight test doubles that conform to Domain protocols. They live in a separate module so they can be shared across both test targets without being compiled into production builds.

- **`TimeManagerMock`** — records call counts, exposes `simulateTick()` to fire the time-update callback on demand.
- **`WonGamesRepositoryMock`** — in-memory store, records `saveGame` / `fetchGame` call counts, and exposes `stubbedGames` / `stubbedError` for scenario control.

## Unit Tests

Tests are written using **Swift Testing** (`import Testing`) and split across two targets that mirror the module structure.

### DomainTests

Pure logic, no async, all `@MainActor`:

- **`BoardBuilderTests`** — verifies board dimensions, queen/conflict reflection, light-square pattern, cell positions, and accessibility identifiers.
- **`ConflictingPositionsManagerTests`** — verifies row, column, diagonal, and anti-diagonal conflict detection; partial conflicts; reset and recalculation.
- **`GameModelTests`** — verifies initial state, queen placement and toggle, the N-queen placement cap, conflict detection and clearing, reset, and win-condition evaluation.

### PresentationTests

Integration of view models with mocks:

- **`GameViewModelTests`** — verifies timer lifecycle (appear / exit / reset), time-tick forwarding, board shape and queen toggling, and the full win path (timer stopped, `wonGame` action fired, game saved to repository).
- **`BestTimesViewModelTests`** — verifies state transitions (loading → empty / loaded / error), ascending sort by elapsed time, formatted time output, and board-size string derivation.

Both test targets apply the same Swift 6 settings as the source targets (`swiftLanguageMode(.v6)`, `defaultIsolation(MainActor.self)`).

# RelaxMinute 🧘‍♂️

A minimalist, elegantly designed 1-minute relaxation timer built with SwiftUI. This app encourages users to take a quick micro-break to breathe deeply, rest their eyes, and regain focus. 

Beyond its simple UI, RelaxMinute is engineered with a robust, production-ready architecture demonstrating advanced iOS development patterns.

## Architecture: MVVM-C (Coordinator Pattern)

The project strictly follows the **Model-View-ViewModel-Coordinator** architecture to ensure maximum decoupling, testability, and clear separation of concerns:

* **Views:** Completely "dumb" and state-driven. They have no knowledge of navigation or complex business logic.
* **ViewModels:** Fully isolated. They manage state (`@Published`), handle business rules (timer logic), and communicate with the Coordinator via closures/Combine publishers without knowing *how* or *where* the user navigates.
* **Coordinator & Router:** A custom `AppCoordinator` handles all application flows. Navigation is managed via a custom `NavigationRouter` utilizing Type Erasure (`AnyScreen`) to abstract SwiftUI's routing complexities.

## 🛠 Tech Stack & Key Technologies

* **UI Framework:** SwiftUI
* **Reactive Programming:** Combine (used for timer ticks and coordinator signaling)
* **Asynchrony:** Swift Concurrency (`async/await`) for modern, safe system permission requests.
* **Local Notifications:** `UserNotifications` framework for background alerts.
* **Persistence:** `UserDefaults` (abstracted via `TimerPersistenceProtocol`).
* **Testing:** **Swift Testing** (Apple's modern testing framework introduced at WWDC24).

## Highlighted Features & Technical Decisions

### 1. Advanced App Lifecycle Management
The app flawlessly handles state transitions (Active, Background, Suspended). Local notifications are **not** blindly scheduled on start. Instead, the `TimerViewModel` dynamically schedules a push notification precisely when the app enters the background, and cancels it upon returning to the foreground, providing the ultimate UX and system resource management.

### 2. State Restoration
If the user minimizes the app or it gets terminated by the system, the timer state (end date and remaining time) is persisted. Upon reopening, the app accurately recalculates the elapsed time and resumes seamlessly.

### 3. Modern Swift Testing
Unit tests are written using the new `Testing` framework (macros like `@Suite`, `@Test`, and `#expect`). The tests natively leverage `async/await` to verify Combine publishers and state transitions without relying on legacy `XCTestExpectation` workarounds.

### 4. Custom Design System
Implemented reusable semantic colors (`AppColors`) and declarative button styles (`TonalButtonStyle`, `SolidButtonStyle`) adapting perfectly to both Light and Dark modes.

### 5. Accessibility (VoiceOver)
The timer ring is fully optimized for visually impaired users. Instead of reading individual UI elements, it combines them and provides a clear, continuously updated accessibility value (e.g., "45 seconds remaining").

## Requirements

* iOS 17.0+
* Xcode 16.0+
* Swift 6.0 (Strict Concurrency enabled)

## How to Run

1. Clone the repository.
2. Open `RelaxMinute.xcodeproj` in Xcode.
3. Select an iPhone simulator or physical device.
4. Press `Cmd + R` to build and run.
5. *Note: To test background notifications on a simulator, start the timer, accept the permission prompt, and press `Cmd + Shift + H` to send the app to the background.*

## Running Tests

Press `Cmd + U` to execute the Unit Test suite. The tests verify the `TimerViewModel`'s state transitions, timer resetting, Coordinator signals, and background notification logic using fully isolated Mocks.

# Quiz Learning App

A Flutter-based quiz learning application built with clean architecture principles, featuring a responsive UI that works seamlessly on both Web and Mobile platforms.

## Features

- ✅ **Clean Architecture**: Feature-first approach with separation of concerns (Domain, Data, Presentation layers)
- ✅ **State Management**: BLoC pattern for predictable state management
- ✅ **Routing**: GoRouter for declarative navigation
- ✅ **Dependency Injection**: GetIt for dependency management
- ✅ **API Integration**: Open Trivia DB API for quiz questions
- ✅ **Local Storage**: SharedPreferences for caching and offline support
- ✅ **Responsive Design**: Optimized for both Web and Mobile devices
- ✅ **Multiple Question Types**: Support for multiple choice and true/false questions
- ✅ **Real-time Feedback**: Immediate answer validation with visual feedback
- ✅ **Progress Tracking**: User progress and quiz statistics
- ✅ **Timer System**: 60-second countdown per question
- ✅ **Countdown Animation**: 3-2-1 countdown before quiz starts
- ✅ **Tests**: Unit tests for use cases and widget tests for UI components

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and strings
│   ├── di/                 # Dependency injection setup
│   ├── error/              # Error handling (failures & exceptions)
│   ├── network/            # Network info
│   ├── router/             # GoRouter configuration
│   ├── theme/              # App theme and text styles
│   └── usecases/           # Base use case classes
├── features/
│   ├── quiz/
│   │   ├── data/
│   │   │   ├── datasources/     # Remote & Local data sources
│   │   │   ├── models/          # Data models with JSON serialization
│   │   │   └── repositories/    # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/        # Business entities
│   │   │   ├── repositories/    # Repository interfaces
│   │   │   └── usecases/        # Business logic
│   │   └── presentation/
│   │       ├── bloc/            # BLoC state management
│   │       ├── screens/         # UI screens
│   │       └── widgets/         # Reusable widgets
│   └── user/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

## Tech Stack

- **Flutter**: SDK ^3.8.1
- **State Management**: flutter_bloc ^9.1.1
- **Routing**: go_router ^16.2.4
- **Dependency Injection**: get_it ^8.2.0
- **HTTP Client**: http ^1.5.0
- **Local Storage**: shared_preferences ^2.5.3
- **Functional Programming**: dartz ^0.10.1
- **Value Equality**: equatable ^2.0.7

## Getting Started

### Prerequisites

- Flutter SDK (^3.8.1)
- Dart SDK (^3.8.1)
- Android Studio / VS Code
- Chrome (for web development)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd quiz_learning
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:

**For Mobile (Android/iOS):**
   ```bash
   flutter run
   ```

   **For Web:**
   ```bash
   flutter run -d chrome
   ```

   **For specific device:**
   ```bash
   # List available devices
   flutter devices

   # Run on specific device
   flutter run -d <device-id>
   ```

## Running Tests

### Unit Tests
```bash
flutter test test/features/quiz/domain/usecases/get_questions_test.dart
flutter test test/features/user/domain/usecases/get_user_test.dart
```

### Widget Tests
```bash
flutter test test/features/quiz/presentation/widgets/option_card_test.dart
```

### All Tests
```bash
flutter test
```

## Clean Architecture Layers

### 1. Domain Layer (Business Logic)
- **Entities**: Pure Dart classes representing core business objects
- **Repositories**: Abstract interfaces defining data operations
- **Use Cases**: Single-responsibility classes containing business logic

### 2. Data Layer (Data Management)
- **Models**: Data models with JSON serialization
- **Data Sources**: 
  - Remote: API calls to Open Trivia DB
  - Local: SharedPreferences for caching
- **Repository Implementations**: Concrete implementations of domain repositories

### 3. Presentation Layer (UI)
- **BLoC**: State management with events and states
- **Screens**: UI screens for different app flows
- **Widgets**: Reusable UI components

## App Flow

1. **Home Screen**: 
   - Displays user information and statistics
   - Shows quiz categories with progress
   - Navigate to countdown on category selection

2. **Countdown Screen**: 
   - 3-second animated countdown (3...2...1)
   - Loads questions from API during countdown
   - Navigates to quiz screen

3. **Quiz Screen**:
   - Displays questions one at a time
   - 60-second timer per question
   - Immediate feedback on answer selection
   - Progress indicator (e.g., Question 3/10 - 30%)
   - Highlights correct/incorrect answers

4. **Result Screen**:
   - Shows quiz statistics (correct, incorrect, total)
   - Displays score percentage and points earned
   - Updates user progress
   - Navigate back to home

## API Integration

The app uses the **Open Trivia Database API** to fetch quiz questions:

**Base URL**: `https://opentdb.com/api.php`

**Example Request**:
```
https://opentdb.com/api.php?amount=10&category=9&difficulty=easy
```

**Parameters**:
- `amount`: Number of questions (default: 10)
- `category`: Category ID (9=General Knowledge, 19=Math, etc.)
- `difficulty`: easy, medium, or hard

## Design Decisions

### 1. Clean Architecture
- **Separation of Concerns**: Each layer has a single responsibility
- **Testability**: Easy to test individual components
- **Maintainability**: Changes in one layer don't affect others
- **Scalability**: Easy to add new features

### 2. BLoC Pattern
- **Predictable State**: Easy to understand app state
- **Reactive**: UI updates automatically based on state changes
- **Separation**: Business logic separated from UI

### 3. Dependency Injection
- **Loose Coupling**: Components don't depend on concrete implementations
- **Testing**: Easy to mock dependencies
- **Flexibility**: Easy to swap implementations

### 4. Feature-First Structure
- **Organization**: Related code grouped together
- **Scalability**: Easy to add new features
- **Team Collaboration**: Different teams can work on different features

## Key Features Implementation

### Timer System
- 60-second countdown per question
- Visual progress bar
- Auto-submit when time expires
- Timer stops on answer submission

### Feedback System
- Immediate visual feedback (green for correct, red for incorrect)
- Feedback message display
- 1-second delay before next question
- Correct answer highlighted

### Progress Tracking
- User statistics (rank, score, quizzes taken)
- Category progress (completed/total quizzes)
- Quiz progress (current question/total questions)
- Percentage completion

### Offline Support
- Categories cached locally
- User data persisted
- Quiz results saved locally
- Categories progress updated locally

## Responsive Design

The app adapts to different screen sizes:

- **Mobile**: Optimized for phones (< 600px width)
- **Web**: Enhanced layout for larger screens (> 600px width)
- **Adaptive UI**: Different text sizes, spacing, and layouts

## Error Handling

- **Network Errors**: Graceful handling with retry option
- **API Errors**: Error messages displayed to user
- **Loading States**: Loading indicators during data fetch
- **Empty States**: Informative messages when no data available

## Future Enhancements

- [ ] Add more question categories
- [ ] Implement leaderboard
- [ ] Add user authentication
- [ ] Support for multiple languages
- [ ] Add sound effects and animations
- [ ] Implement quiz history
- [ ] Add difficulty selection
- [ ] Social sharing of results

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is created as a coding assessment and is available for educational purposes.

## Acknowledgments

- Open Trivia Database for providing the quiz API
- Flutter team for the amazing framework
- BLoC library contributors

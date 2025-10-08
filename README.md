# Quiz Learning App

A modern, responsive Flutter quiz application that works seamlessly on Web and Mobile platforms. This app features a beautiful UI with multiple quiz categories, real-time feedback, and progress tracking.

## 📱 Features (Static UI - Step 1)

- **Responsive Design**: Works beautifully on mobile, tablet, and web
- **Modern UI**: Clean, intuitive interface with smooth animations
- **User Dashboard**: Displays user stats including rank, score, and progress
- **Quiz Categories**: 5 different quiz categories with progress tracking:
  - General Knowledge
  - Mathematics
  - Science & Nature
  - History
  - Sports
- **Countdown Animation**: 3-2-1 countdown before quiz starts
- **Quiz Interface**: 
  - Question progress indicator (e.g., 3/10 - 30%)
  - Multiple choice and True/False question support
  - Timer display (60 seconds per question)
  - Immediate visual feedback (green for correct, red for incorrect)
  - Feedback messages
- **Result Screen**: Detailed quiz results with score breakdown

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart       # App-wide constants
│   ├── router/
│   │   └── app_router.dart          # GoRouter configuration
│   └── theme/
│       └── app_theme.dart           # App theme and colors
├── models/
│   ├── question_model.dart          # Question data model
│   ├── quiz_category_model.dart     # Quiz category model
│   ├── quiz_result_model.dart       # Result data model
│   └── user_model.dart              # User data model
├── screens/
│   ├── home_screen.dart             # Main home screen
│   ├── countdown_screen.dart        # 3-2-1 countdown screen
│   ├── quiz_screen.dart             # Quiz question screen
│   └── result_screen.dart           # Results display screen
├── widgets/
│   ├── option_card.dart             # Quiz option widget
│   ├── quiz_category_card.dart      # Category card widget
│   └── user_header_widget.dart      # User header widget
└── main.dart                        # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- An IDE (VS Code, Android Studio, or IntelliJ IDEA)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd quiz_learning
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**

   **For Mobile (iOS/Android):**
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

### Build Commands

**Build for Web:**
```bash
flutter build web
```

**Build for Android:**
```bash
flutter build apk --release
```

**Build for iOS:**
```bash
flutter build ios --release
```

## 📦 Dependencies

### Core Dependencies
- **flutter_bloc** (^8.1.6) - State management
- **equatable** (^2.0.5) - Value equality
- **get_it** (^8.0.2) - Dependency injection
- **go_router** (^14.6.2) - Declarative routing
- **http** (^1.2.2) - HTTP client for API calls
- **shared_preferences** (^2.3.3) - Local storage

### Dev Dependencies
- **flutter_test** - Testing framework
- **flutter_lints** (^5.0.0) - Linting rules

## 🎨 Design Decisions

### UI/UX
- **Color Scheme**: Modern purple/indigo theme with clean white backgrounds
- **Typography**: Clear hierarchy with bold headings and readable body text
- **Spacing**: Responsive padding that adapts to screen size
- **Feedback**: Immediate visual feedback with color-coded responses
- **Accessibility**: High contrast colors and clear iconography

### Architecture
- **Clean Architecture**: Separation of concerns with models, screens, and widgets
- **Modular Design**: Reusable components and clear file structure
- **Scalability**: Easy to extend with new features and quiz categories

### Responsive Design
- Breakpoint at 600px for mobile/web distinction
- Adaptive font sizes and spacing
- Flexible layouts that work on all screen sizes

## 🧪 Testing

### Run Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## 🔄 Current Status (Step 1: Static UI)

✅ **Completed:**
- [x] Project structure setup
- [x] Dependencies configuration
- [x] Theme implementation
- [x] Data models (User, Category, Question, Result)
- [x] Reusable widgets (Header, Cards, Options)
- [x] Home screen with user stats and categories
- [x] Countdown animation screen
- [x] Quiz screen with questions and options
- [x] Result screen with score breakdown
- [x] GoRouter setup for navigation
- [x] Responsive design for mobile and web

📋 **Next Steps (Step 2+):**
- [ ] Bloc implementation for state management
- [ ] Open Trivia DB API integration
- [ ] Timer functionality
- [ ] Score calculation logic
- [ ] Local storage for progress
- [ ] Unit and widget tests
- [ ] Animation enhancements

## 🌐 API Integration (Planned)

The app is designed to integrate with [Open Trivia Database API](https://opentdb.com/):

**Example API URL:**
```
https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple
```

**Categories configured:**
- General Knowledge (ID: 9)
- Mathematics (ID: 19)
- Science & Nature (ID: 17)
- History (ID: 23)
- Sports (ID: 21)

## 📸 Screenshots

### Home Screen
- User header with avatar and progress
- User stats (Rank, Score, Completed quizzes)
- Quiz category cards with individual progress

### Countdown Screen
- Category icon and name
- Animated countdown (3-2-1)
- "Get Ready!" message

### Quiz Screen
- Progress bar (Question X/10 - XX%)
- Question type badge
- Question text
- Multiple options with selection state
- Timer with progress bar
- Feedback labels (Correct/Incorrect)

### Result Screen
- Success/encouragement icon
- Score percentage in circular display
- Detailed stats (Correct, Incorrect, Total)
- Points earned display
- Back to home button

## 🤝 Contributing

This is a coding assessment project. For production use, consider:
- Adding error boundaries
- Implementing analytics
- Adding accessibility features
- Internationalization support
- Performance optimization

## 📝 License

This project is created as a coding assessment.

## 👤 Author

Created as part of a Flutter Developer assessment.

---

**Note:** This is currently a static UI implementation (Step 1). Full functionality including state management, API integration, and testing will be implemented in subsequent steps.

# Copilot Instructions for SavePenny

Welcome to the SavePenny Flutter project! This document provides essential guidelines for AI coding agents to be productive in this codebase. Follow these instructions to understand the project's structure, workflows, and conventions.

## Project Overview
SavePenny is a Flutter application designed to manage personal finances. The project supports multiple platforms, including Android, iOS, web, and desktop (Windows, macOS, Linux). The codebase is structured to ensure modularity and scalability.

### Key Directories
- `lib/`: Contains the main application code.
  - `Components/`: Reusable UI components (e.g., `EmailTextField`, `SocialButton`).
  - `Screens/`: Screen-specific widgets and logic (e.g., `signUp.dart`, `mainScreen/`).
  - `Utils/`: Utility functions and classes (e.g., `PerformanceRecord`, `Wallet`).
- `assets/`: Stores static assets like icons and images.
- `test/`: Contains widget tests.
- `android/`, `ios/`, `linux/`, `macos/`, `windows/`, `web/`: Platform-specific configurations and code.

## Developer Workflows

### Building the Project
Run the following command to build the project for your target platform:
```powershell
flutter build <platform>
```
Replace `<platform>` with `apk`, `ios`, `web`, etc.

### Running the Project
To run the project on a connected device or emulator:
```powershell
flutter run
```

### Testing
Run widget tests using:
```powershell
flutter test
```

### Formatting and Linting
Ensure code is formatted and follows linting rules:
```powershell
flutter format .; flutter analyze
```

## Project-Specific Conventions

### State Management
This project uses Flutter's built-in `StatefulWidget` and `Provider` for state management. Ensure state is managed locally within widgets or globally using `Provider` where necessary.

### File Naming
- Use `snake_case` for file names (e.g., `email_text_field.dart`).
- Group related files in subdirectories (e.g., `Screens/mainScreen/`).

### UI Components
- Reusable components are stored in `lib/Components/`.
- Follow the existing patterns in files like `EmailTextField.dart` and `SocialButton.dart`.

### Testing
- Write widget tests for all new screens and components.
- Use the `test/widget_test.dart` file as a reference.

## Integration Points

### External Dependencies
- The project relies on Flutter's core libraries and common packages. Check `pubspec.yaml` for a complete list.
- Run `flutter pub get` to install dependencies.

### Cross-Component Communication
- Use `Provider` for passing data between widgets.
- Avoid direct imports of sibling components; use relative paths instead.

## Examples

### Adding a New Screen
1. Create a new file in `lib/Screens/` (e.g., `new_screen.dart`).
2. Define a `StatelessWidget` or `StatefulWidget`.
3. Add navigation logic in `main.dart` or the relevant parent screen.

### Adding a New Component
1. Create a new file in `lib/Components/` (e.g., `custom_button.dart`).
2. Follow the pattern in existing components like `SocialButton.dart`.

---

For any questions or clarifications, refer to the Flutter documentation or existing patterns in the codebase. Happy coding!
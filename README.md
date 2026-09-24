# TaskFlow ⚡ - Modern Flutter To-Do List Application

TaskFlow is a complete, feature-rich Flutter To-Do List application built with a modern Material 3 UI/UX design, custom soft gradients, interactive animations, and local persistence.

Designed specifically to demonstrate clean state management using Flutter's native `setState()`, clean project modularity, and production-grade UI design practices.

---

## 🎨 UI/UX Features & Highlights

- **Material 3 Design & Themes**: Custom soft light and dark themes with Google Fonts (`Poppins`), curved cards, and soft shadows.
- **Top Summary Card**: Real-time progress bar showing total vs completed tasks ratio (e.g. *"3 of 8 completed"*) with motivational feedback.
- **Task Card Micro-interactions**:
  - Custom animated checkbox for completing tasks.
  - Strikethrough text with smooth opacity transitions.
  - Swipe-to-delete (`Dismissible`) with confirmation dialog and SnackBar **Undo** action.
- **Priority & Category Tags**:
  - **Priorities**: Low (Green), Medium (Amber), High (Red).
  - **Categories**: Work, Personal, Shopping, Health, Education, Other.
- **Modal Bottom Sheet**: Clean task creation & editing modal with validation (prevents empty task title), priority selector, category chips, and due date picker.
- **Real-Time Search & Filters**: Search tasks by keyword and filter by status (All, Active, Completed) or category.
- **Dark/Light Mode**: AppBar theme toggle button.
- **Local Storage Persistence**: Automatically saves and loads tasks using `shared_preferences` JSON string encoding so tasks remain after app restart.

---

## 📁 Project Architecture & File Structure

```
lib/
├── main.dart                          # Root app setup & ThemeMode toggle state
├── models/
│   ├── task.dart                      # Task data model with JSON serialization
│   ├── priority.dart                  # TaskPriority enum with UI attributes
│   └── category.dart                  # TaskCategory enum with icons & colors
├── theme/
│   ├── app_colors.dart                # Color tokens & gradients for Light & Dark mode
│   └── app_theme.dart                 # Material 3 ThemeData configurations
├── services/
│   └── storage_service.dart           # SharedPreferences JSON persistence service
├── screens/
│   └── home_screen.dart               # Main dashboard managing state & task operations
└── widgets/
    ├── task_card.dart                 # Swipeable task item card widget
    ├── add_edit_task_bottom_sheet.dart# Modal bottom sheet for adding/editing tasks
    ├── task_summary_card.dart         # Progress header card with animated bar
    ├── empty_state_widget.dart        # Empty state placeholder layout
    ├── filter_chip_bar.dart           # Search & filter chip controls
    ├── priority_badge.dart            # Priority badge widget
    └── category_badge.dart            # Category chip widget
```

---

## 🚀 How to Run the Application

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or higher) installed on your system.
- Android Studio / Xcode / VS Code with Flutter extension.

### Running Commands

1. **Get Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run on Connected Device / Simulator**:
   ```bash
   flutter run
   ```

3. **Run on Web**:
   ```bash
   flutter run -d chrome
   ```

---

## 💡 Key Educational Takeaways for Beginners

1. **State Management (`setState`)**:
   Notice how `HomeScreen` maintains `_tasks`, `_searchQuery`, and filters in standard `StatefulWidget` state. Updating the list calls `setState()`, causing Flutter to efficiently re-render the UI components.

2. **JSON Data Serialization**:
   Inspect [`lib/models/task.dart`](file:///c:/Users/amila/Documents/To-Do%20List/lib/models/task.dart) to see how `toJson()` and `fromJson()` serialize task data so it can be stored into `SharedPreferences` as a JSON string in [`lib/services/storage_service.dart`](file:///c:/Users/amila/Documents/To-Do%20List/lib/services/storage_service.dart).

3. **Separation of Concerns**:
   - `models/`: Plain Data Classes and Business Enums.
   - `theme/`: Styling, Fonts, Colors, and Material 3 design system.
   - `widgets/`: Reusable, modular presentation components.
   - `screens/`: Layout assemblies and controller logic.

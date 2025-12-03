# Journal App

A beautiful iOS journal application built with SwiftUI that allows users to capture their daily thoughts, track moods, and maintain writing streaks.

## Features

### 📝 Journal Entries
- Create, edit, and delete journal entries
- Rich text editor for detailed entries
- Custom titles for each entry
- Date and time picker for backdating entries

### 😊 Mood Tracking
- Track your mood for each entry with 5 different moods:
  - Amazing ⭐
  - Happy 😊
  - Neutral ➖
  - Sad 🌧️
  - Stressed ⚠️
- Visual mood indicators with colors and icons

### 🏠 Home Dashboard
- Summary cards showing:
  - Total number of entries
  - Current writing streak
  - Overall mood
- Quick action to write new entries
- Recent entries list with preview

### 📅 Calendar View
- Interactive calendar with month navigation
- Visual indicators for days with journal entries
- View all entries for a specific date
- Create entries for any date

### 👤 Profile & Settings
- User statistics
- Settings options
- Export data capability

### 🎨 Beautiful UI
- Modern iOS design with SwiftUI
- Smooth animations and transitions
- Gradient backgrounds
- Card-based layouts
- Dark mode support

## Technical Details

- **Platform**: iOS 17.0+
- **Language**: Swift 5.0
- **Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **Data Management**: ObservableObject with @Published properties

## Project Structure

```
MyNewJournalApp/
├── Models/
│   └── JournalEntry.swift          # Data model for journal entries and moods
├── ViewModels/
│   └── JournalViewModel.swift      # Business logic and state management
├── Views/
│   ├── ContentView.swift           # Landing page
│   ├── MainTabView.swift           # Tab navigation
│   ├── HomeView.swift              # Home dashboard
│   ├── CalendarView.swift          # Calendar interface
│   ├── NewEntryView.swift          # Create new entry
│   ├── EditEntryView.swift         # Edit existing entry
│   └── EntryDetailView.swift       # View entry details
└── Assets.xcassets/                # App icons and colors
```

## Getting Started

### Prerequisites
- Xcode 15.0 or later
- macOS 14.0 or later
- iOS 17.0+ device or simulator

### Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/journal-app.git
```

2. Open the project in Xcode:
```bash
cd journal-app/MyNewJournalApp
open MyNewJournalApp.xcodeproj
```

3. Build and run the project:
   - Select your target device or simulator
   - Press `Cmd + R` or click the Run button

## Usage

1. **Getting Started**: Launch the app and tap "Get Started" on the landing page
2. **Create Entry**: Tap the "Write New Entry" button on the home screen
3. **Select Mood**: Choose your current mood from the mood selector
4. **Write**: Add a title and write your thoughts
5. **Save**: Tap "Save" to store your entry
6. **View Entries**: Browse entries on the home screen or calendar view
7. **Edit/Delete**: Tap an entry, then use the menu to edit or delete

## Screenshots

*Add screenshots here*

## Sample Data

The app comes with 5 sample journal entries to demonstrate functionality. These can be deleted or edited as needed.

## Future Enhancements

- [ ] iCloud sync
- [ ] Search functionality
- [ ] Tags and categories
- [ ] Export to PDF
- [ ] Reminders and notifications
- [ ] Photo attachments
- [ ] Themes customization
- [ ] Password protection

## License

This project is available for personal and educational use.

## Author

Masood Ahamed

## Acknowledgments

- Built with SwiftUI
- Icons from SF Symbols
- Inspired by modern journaling apps

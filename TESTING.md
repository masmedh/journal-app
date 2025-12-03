# Testing Guide

This guide outlines how to verify the offline persistence and cloud sync features of the Journal App.

## Prerequisites

1. **Link Firebase Libraries**:

   - Open `MyNewJournalApp.xcodeproj` in Xcode.
   - Select the project in the Project Navigator (blue icon).
   - Select the `MyNewJournalApp` target.
   - Go to the **General** tab -> **Frameworks, Libraries, and Embedded Content**.
   - Click **+** and add:
     - `FirebaseFirestore`
     - `FirebaseCore`
     - `FirebaseAuth` (if you added it)

2. **GoogleService-Info.plist**:
   - Ensure this file is in your project root and added to the target.

## Manual Test Cases

### 1. Offline Persistence (Core Data)

**Goal**: Verify entries are saved locally and persist across app restarts.

1.  **Launch App**: Open the app on Simulator or Device.
2.  **Create Entry**: Tap "Write New Entry", add title/content/mood, and Save.
3.  **Verify UI**: The new entry should appear on the Home screen.
4.  **Force Quit**: Swipe up from the bottom (Simulator) to close the app completely.
5.  **Relaunch**: Open the app again.
6.  **Verify**: The entry should still be there.

### 2. Cloud Sync (Firebase)

**Goal**: Verify entries are synced to the cloud.

1.  **Online Mode**: Ensure Simulator/Device has internet.
2.  **Create Entry**: Create a new entry titled "Cloud Test".
3.  **Check Console**: Go to [Firebase Console](https://console.firebase.google.com/).
    - Navigate to **Firestore Database**.
    - Look for `users` collection -> `{your-user-id}` -> `entries`.
    - You should see a document with title "Cloud Test".

### 3. Data Restoration (Fresh Install)

**Goal**: Verify data is pulled from cloud on fresh install.

1.  **Delete App**: Long press the app icon -> Remove App -> Delete App.
2.  **Reinstall**: Run the app from Xcode again.
3.  **Wait**: On launch, wait a few seconds for the sync to complete.
4.  **Verify**: Your previous entries (including "Cloud Test") should appear.

### 4. Conflict Resolution

**Goal**: Verify "Last Write Wins" logic.

1.  **Device A**: Edit an entry, change title to "Edit A". Save.
2.  **Device B** (or Simulator): Open app, wait for sync. Title should become "Edit A".
3.  **Offline Edit**: Turn off WiFi on Device A. Change title to "Offline Edit". Save.
4.  **Online Edit**: On Device B, change title to "Online Edit". Save.
5.  **Sync**: Turn WiFi back on Device A.
6.  **Result**: The app should eventually converge to the version with the latest `updatedAt` timestamp.

## Troubleshooting

- **Build Fails**: "Unable to find module dependency 'FirebaseFirestore'".
  - **Fix**: Follow the "Link Firebase Libraries" step above.
- **Crash on Launch**: "Model not found" or similar.
  - **Fix**: Ensure `JournalModel.xcdatamodeld` is created and has the correct Entity `CDJournalEntry`.
- **No Sync**:
  - Check debug console for "Sync failed" messages.
  - Verify `GoogleService-Info.plist` is valid.

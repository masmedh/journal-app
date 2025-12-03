
import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
  }
}

---

Source Control Guidance

- Do not commit `GoogleService-Info.plist` to public repositories.
- The repo `.gitignore` ignores `MyNewJournalApp/MyNewJournalApp/GoogleService-Info.plist`.
- Each developer should place their own plist locally and add it to the Xcode target.
- If the plist was previously committed to a public repo, rotate keys in Firebase console.
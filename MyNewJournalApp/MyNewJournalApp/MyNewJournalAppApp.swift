//
//  MyNewJournalAppApp.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import CoreData

@main
struct MyNewJournalAppApp: App {
    @StateObject private var viewModel: JournalViewModel
    
    init() {
        FirebaseApp.configure()
        
        let persistenceController = PersistenceController.shared
        let localStore = CoreDataJournalStore(context: persistenceController.container.viewContext)

        // Persist user ID in Keychain to survive app reinstalls
        let userId = UserIdManager.getOrCreateUserId()

        let remoteStore = FirebaseJournalStore(userId: userId)
        
        _viewModel = StateObject(wrappedValue: JournalViewModel(localStore: localStore, remoteStore: remoteStore))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

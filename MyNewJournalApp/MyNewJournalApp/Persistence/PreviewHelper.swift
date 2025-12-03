//
//  PreviewHelper.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import Foundation
import CoreData

struct PreviewHelper {
    static let shared = PreviewHelper()
    
    let persistenceController: PersistenceController
    let localStore: CoreDataJournalStore
    let viewModel: JournalViewModel
    
    init() {
        persistenceController = PersistenceController(inMemory: true)
        localStore = CoreDataJournalStore(context: persistenceController.container.viewContext)
        
        // Add sample data
        let sampleEntries = [
            JournalEntry(title: "Sample 1", content: "Content 1", mood: .happy),
            JournalEntry(title: "Sample 2", content: "Content 2", mood: .neutral)
        ]
        
        for entry in sampleEntries {
            try? localStore.add(entry)
        }
        
        viewModel = JournalViewModel(localStore: localStore)
    }
}

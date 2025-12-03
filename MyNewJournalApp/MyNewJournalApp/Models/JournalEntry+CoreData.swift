//
//  JournalEntry+CoreData.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import Foundation
import CoreData

extension JournalEntry {
    init(cdEntry: CDJournalEntry) {
        self.id = cdEntry.id ?? UUID()
        self.title = cdEntry.title ?? ""
        self.content = cdEntry.content ?? ""
        self.date = cdEntry.createdAt ?? Date()
        self.updatedAt = cdEntry.updatedAt ?? Date()
        // Assuming mood is stored as Int16
        self.mood = Mood.allCases.indices.contains(Int(cdEntry.mood)) ? Mood.allCases[Int(cdEntry.mood)] : .neutral
    }
    
    func apply(to cdEntry: CDJournalEntry) {
        cdEntry.id = self.id
        cdEntry.title = self.title
        cdEntry.content = self.content
        cdEntry.createdAt = self.date
        cdEntry.updatedAt = self.updatedAt
        
        // Map Mood to Int16
        if let index = Mood.allCases.firstIndex(of: self.mood) {
            cdEntry.mood = Int16(index)
        } else {
            cdEntry.mood = 0 // Default to first case
        }
    }
}

// Helper to init from CDJournalEntry with index mapping
extension JournalEntry {
    init(cdEntry: CDJournalEntry, moodIndex: Int16) {
        self.id = cdEntry.id ?? UUID()
        self.title = cdEntry.title ?? ""
        self.content = cdEntry.content ?? ""
        self.date = cdEntry.createdAt ?? Date()
        self.updatedAt = cdEntry.updatedAt ?? Date()
        
        let index = Int(moodIndex)
        if Mood.allCases.indices.contains(index) {
            self.mood = Mood.allCases[index]
        } else {
            self.mood = .neutral
        }
    }
}

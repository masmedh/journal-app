//
//  MockRemoteJournalStore.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/4/25.
//

import Foundation

class MockRemoteJournalStore: RemoteJournalStore {
    var entries: [JournalEntry] = []
    
    func fetchEntriesRemote() async throws -> [JournalEntry] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        return entries
    }
    
    func pushEntry(_ entry: JournalEntry) async throws {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        } else {
            entries.append(entry)
        }
    }
    
    func deleteRemote(id: UUID) async throws {
        entries.removeAll { $0.id == id }
    }
}

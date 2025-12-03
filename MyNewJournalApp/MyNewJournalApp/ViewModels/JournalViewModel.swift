//
//  JournalViewModel.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import Foundation
import SwiftUI
import Combine

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var errorMessage: String?
    
    private let localStore: JournalStore
    private let remoteStore: RemoteJournalStore?
    
    init(localStore: JournalStore, remoteStore: RemoteJournalStore? = nil) {
        self.localStore = localStore
        self.remoteStore = remoteStore
        loadEntries()
        Task {
            await sync()
        }
    }
    
    func loadEntries() {
        do {
            entries = try localStore.fetchEntries()
        } catch {
            errorMessage = "Failed to load entries: \(error.localizedDescription)"
        }
    }
    
    func sync() async {
        guard let remoteStore = remoteStore else { return }
        
        do {
            let remoteEntries = try await remoteStore.fetchEntriesRemote()
            
            // Simple merge strategy:
            // 1. If remote entry doesn't exist locally, add it.
            // 2. If remote entry exists locally, keep the one with later updatedAt.
            // 3. If local entry doesn't exist remotely, push it? (Or assume it was deleted remotely? For now, push local to remote)
            
            var mergedEntries = entries
            
            for remoteEntry in remoteEntries {
                if let localIndex = mergedEntries.firstIndex(where: { $0.id == remoteEntry.id }) {
                    let localEntry = mergedEntries[localIndex]
                    if remoteEntry.updatedAt > localEntry.updatedAt {
                        // Remote is newer, update local
                        try localStore.update(remoteEntry)
                        mergedEntries[localIndex] = remoteEntry
                    } else if localEntry.updatedAt > remoteEntry.updatedAt {
                        // Local is newer, push to remote
                        try await remoteStore.pushEntry(localEntry)
                    }
                } else {
                    // New from remote, add to local
                    try localStore.add(remoteEntry)
                    mergedEntries.append(remoteEntry)
                }
            }
            
            // Check for local entries that are not in remote (newly created offline)
            let remoteIds = Set(remoteEntries.map { $0.id })
            for localEntry in entries {
                if !remoteIds.contains(localEntry.id) {
                    try await remoteStore.pushEntry(localEntry)
                }
            }
            
            // Reload from local store to ensure UI is in sync
            await MainActor.run {
                loadEntries()
            }
            
        } catch {
            await MainActor.run {
                errorMessage = "Sync failed: \(error.localizedDescription)"
            }
        }
    }
    
    func addEntry(_ entry: JournalEntry) {
        do {
            try localStore.add(entry)
            entries.append(entry)
            entries.sort { $0.date > $1.date }
            
            Task {
                try? await remoteStore?.pushEntry(entry)
            }
        } catch {
            errorMessage = "Failed to save entry: \(error.localizedDescription)"
        }
    }
    
    func updateEntry(_ entry: JournalEntry) {
        var updatedEntry = entry
        updatedEntry.updatedAt = Date()
        
        do {
            try localStore.update(updatedEntry)
            
            if let index = entries.firstIndex(where: { $0.id == entry.id }) {
                entries[index] = updatedEntry
                entries.sort { $0.date > $1.date }
            }
            
            Task {
                try? await remoteStore?.pushEntry(updatedEntry)
            }
        } catch {
            errorMessage = "Failed to update entry: \(error.localizedDescription)"
        }
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        do {
            try localStore.delete(id: entry.id)
            entries.removeAll { $0.id == entry.id }
            
            Task {
                try? await remoteStore?.deleteRemote(id: entry.id)
            }
        } catch {
            errorMessage = "Failed to delete entry: \(error.localizedDescription)"
        }
    }
    
    func entriesForDate(_ date: Date) -> [JournalEntry] {
        entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func entriesForMonth(_ date: Date) -> [JournalEntry] {
        entries.filter { 
            Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month)
        }
    }
    
    var totalEntries: Int {
        entries.count
    }
    
    var currentStreak: Int {
        guard !entries.isEmpty else { return 0 }
        
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        while true {
            if entries.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }) {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            } else if streak == 0 && currentDate == Calendar.current.startOfDay(for: Date()) {
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        return streak
    }
    
    var averageMood: Mood {
        guard !entries.isEmpty else { return .neutral }
        
        let moodCounts = entries.reduce(into: [Mood: Int]()) { counts, entry in
            counts[entry.mood, default: 0] += 1
        }
        
        return moodCounts.max(by: { $0.value < $1.value })?.key ?? .neutral
    }
}

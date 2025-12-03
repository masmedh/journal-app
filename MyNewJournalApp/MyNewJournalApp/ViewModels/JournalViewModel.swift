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
    
    init() {
        loadSampleData()
    }
    
    func addEntry(_ entry: JournalEntry) {
        entries.append(entry)
        entries.sort { $0.date > $1.date }
    }
    
    func updateEntry(_ entry: JournalEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            entries.sort { $0.date > $1.date }
        }
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
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
    
    private func loadSampleData() {
        let calendar = Calendar.current
        
        entries = [
            JournalEntry(
                title: "A Great Day",
                content: "Today was amazing! I finally finished my project and celebrated with friends.",
                date: Date(),
                mood: .amazing
            ),
            JournalEntry(
                title: "Morning Thoughts",
                content: "Started the day with a peaceful walk. Feeling grateful for the small things.",
                date: calendar.date(byAdding: .day, value: -1, to: Date())!,
                mood: .happy
            ),
            JournalEntry(
                title: "Busy Week",
                content: "Work has been overwhelming but I'm managing. Taking it one step at a time.",
                date: calendar.date(byAdding: .day, value: -3, to: Date())!,
                mood: .stressed
            ),
            JournalEntry(
                title: "Reflection",
                content: "Thinking about my goals and what I want to achieve this month.",
                date: calendar.date(byAdding: .day, value: -5, to: Date())!,
                mood: .neutral
            ),
            JournalEntry(
                title: "Weekend Plans",
                content: "Looking forward to a relaxing weekend. Planning to read and catch up on rest.",
                date: calendar.date(byAdding: .day, value: -7, to: Date())!,
                mood: .happy
            )
        ]
    }
}

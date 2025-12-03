//
//  JournalEntry.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import Foundation

struct JournalEntry: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var date: Date
    var updatedAt: Date
    var mood: Mood
    
    init(id: UUID = UUID(), title: String, content: String, date: Date = Date(), updatedAt: Date = Date(), mood: Mood = .neutral) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
        self.updatedAt = updatedAt
        self.mood = mood
    }
}

enum Mood: String, Codable, CaseIterable {
    case amazing = "Amazing"
    case happy = "Happy"
    case neutral = "Neutral"
    case sad = "Sad"
    case stressed = "Stressed"
    
    var icon: String {
        switch self {
        case .amazing: return "star.fill"
        case .happy: return "face.smiling.fill"
        case .neutral: return "minus.circle.fill"
        case .sad: return "cloud.rain.fill"
        case .stressed: return "exclamationmark.triangle.fill"
        }
    }
    
    var color: String {
        switch self {
        case .amazing: return "yellow"
        case .happy: return "green"
        case .neutral: return "blue"
        case .sad: return "indigo"
        case .stressed: return "red"
        }
    }
}

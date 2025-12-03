//
//  JournalEntry+Firebase.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import Foundation
import FirebaseFirestore

extension JournalEntry {
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        guard let idString = data["id"] as? String,
              let id = UUID(uuidString: idString),
              let title = data["title"] as? String,
              let content = data["content"] as? String,
              let moodInt = data["mood"] as? Int,
              let createdAtTimestamp = data["createdAt"] as? Timestamp else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.content = content
        self.date = createdAtTimestamp.dateValue()
        
        if let updatedAtTimestamp = data["updatedAt"] as? Timestamp {
            self.updatedAt = updatedAtTimestamp.dateValue()
        } else {
            self.updatedAt = self.date
        }
        
        if Mood.allCases.indices.contains(moodInt) {
            self.mood = Mood.allCases[moodInt]
        } else {
            self.mood = .neutral
        }
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id.uuidString,
            "title": title,
            "content": content,
            "mood": Mood.allCases.firstIndex(of: mood) ?? 2, // Default to neutral index
            "createdAt": Timestamp(date: date),
            "updatedAt": Timestamp(date: updatedAt)
        ]
    }
}

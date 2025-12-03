//
//  FirebaseJournalStore.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import Foundation
import FirebaseFirestore

class FirebaseJournalStore: RemoteJournalStore {
    private let db: Firestore
    private let userId: String
    
    init(firestore: Firestore = Firestore.firestore(), userId: String) {
        self.db = firestore
        self.userId = userId
    }
    
    private var collectionRef: CollectionReference {
        db.collection("users").document(userId).collection("entries")
    }
    
    func fetchEntriesRemote() async throws -> [JournalEntry] {
        let snapshot = try await collectionRef.getDocuments()
        return snapshot.documents.compactMap { JournalEntry(document: $0) }
    }
    
    func pushEntry(_ entry: JournalEntry) async throws {
        try await collectionRef.document(entry.id.uuidString).setData(entry.toFirestoreData())
    }
    
    func deleteRemote(id: UUID) async throws {
        try await collectionRef.document(id.uuidString).delete()
    }
}

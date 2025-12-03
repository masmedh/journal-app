//
//  JournalStore.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import Foundation

protocol JournalStore {
    func fetchEntries() throws -> [JournalEntry]
    func add(_ entry: JournalEntry) throws
    func update(_ entry: JournalEntry) throws
    func delete(id: UUID) throws
}

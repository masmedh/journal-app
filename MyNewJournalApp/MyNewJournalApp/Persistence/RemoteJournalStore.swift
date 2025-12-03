//
//  RemoteJournalStore.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import Foundation

protocol RemoteJournalStore {
    func fetchEntriesRemote() async throws -> [JournalEntry]
    func pushEntry(_ entry: JournalEntry) async throws
    func deleteRemote(id: UUID) async throws
}

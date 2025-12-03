//
//  CoreDataJournalStore.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import Foundation
import CoreData

class CoreDataJournalStore: JournalStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchEntries() throws -> [JournalEntry] {
        let request = NSFetchRequest<CDJournalEntry>(entityName: "CDJournalEntry")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDJournalEntry.createdAt, ascending: false)]
        
        let cdEntries = try context.fetch(request)
        return cdEntries.map { JournalEntry(cdEntry: $0) }
    }
    
    func add(_ entry: JournalEntry) throws {
        let cdEntry = CDJournalEntry(context: context)
        entry.apply(to: cdEntry)
        try saveContext()
    }
    
    func update(_ entry: JournalEntry) throws {
        let request = NSFetchRequest<CDJournalEntry>(entityName: "CDJournalEntry")
        request.predicate = NSPredicate(format: "id == %@", entry.id as CVarArg)
        request.fetchLimit = 1
        
        if let cdEntry = try context.fetch(request).first {
            entry.apply(to: cdEntry)
            try saveContext()
        } else {
            // If not found, treat as add? Or throw?
            // For now, let's add it if it doesn't exist (upsert)
            try add(entry)
        }
    }
    
    func delete(id: UUID) throws {
        let request = NSFetchRequest<CDJournalEntry>(entityName: "CDJournalEntry")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        if let cdEntry = try context.fetch(request).first {
            context.delete(cdEntry)
            try saveContext()
        }
    }
    
    private func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

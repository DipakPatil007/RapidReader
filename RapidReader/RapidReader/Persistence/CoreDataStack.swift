//
//  CoreDataStack.swift
//  Rapid-Reader
//
//  Created by Dipak on 16/09/25.
//
import CoreData
import Foundation

// Core Data Class
final class CoreDataStack {
    // Singleton object of the coredatastack
    static let shared = CoreDataStack()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RapidReader")
        container.loadPersistentStores { desc, error in
            if let e = error { fatalError("Core Data failed to load: \(e)") }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()

    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

    func saveContext() {
        let ctx = viewContext
        if ctx.hasChanges {
            do { try ctx.save() } catch { print("Failed to save context: \(error)") }
        }
    }
}

//
//  Persistence.swift
//  PicPoof
//
//  Created by Anya Popova on 2024-12-11.
//

import SwiftUI
import CoreData
import Foundation


struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PicPoofModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
extension MonthProgress {
    static func fetchRequest(year: String, month: String) -> FetchRequest<MonthProgress> {
        FetchRequest(
            entity: MonthProgress.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "year == %@ AND month == %@", year, month)
        )
    }
}

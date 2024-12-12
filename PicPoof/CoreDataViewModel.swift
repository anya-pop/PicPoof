//
//  CoreDataViewModel.swift
//  PicPoof
//  991 694 498
//  991 683 351
//  Anya Popova
//  Aleks Bursac
//  PROG31975
//  Created by Anya Popova on 2024-12-11.
//


import Foundation
import CoreData

class CoreDataViewModel: ObservableObject {
    @Published var monthProgressList: [MonthProgress] = []
    let viewContext = PersistenceController.shared.container.viewContext

    init() {
        fetchMonthProgress()
    }

    func fetchMonthProgress() {
        let request = NSFetchRequest<MonthProgress>(entityName: "MonthProgress")
        do {
            monthProgressList = try viewContext.fetch(request)
        } catch {
            print("Error fetching month progress: \(error)")
        }
    }

    func markMonthAsCompleted(year: String, month: String) {
        let fetchRequest = NSFetchRequest<MonthProgress>(entityName: "MonthProgress")
        fetchRequest.predicate = NSPredicate(format: "year == %@ AND month == %@", year, month)

        do {
            let existingProgress = try viewContext.fetch(fetchRequest)
            let progress = existingProgress.first ?? MonthProgress(context: viewContext)
            progress.year = year
            progress.month = month
            progress.isCompleted = true

            try viewContext.save()
        } catch {
            print("Error marking month as completed: \(error)")
        }
    }

    func isMonthCompleted(year: String, month: String) -> Bool {
        monthProgressList.first(where: { $0.year == year && $0.month == month })?.isCompleted == true
    }
}

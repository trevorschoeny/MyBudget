//
//  Balances.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/8/21.
//

import Foundation
import CoreData

class Balances: ObservableObject {
   
   @Published var totalBalance = 0.0
   @Published var totalAssets = 0.0
   @Published var totalLiabilities = 0.0
   @Published var currentAssets = 0.0
   @Published var currentLiabilities = 0.0
   @Published var currentBalance = 0.0
   
   init() {
      for a in fetchAccounts() {
         totalBalance += a.balance
         if a.balance > 0 {
            totalAssets += a.balance
         } else {
            totalLiabilities += a.balance
         }
         if a.isCurrent {
            currentBalance += a.balance
            if a.balance > 0 {
               currentAssets += a.balance
            } else {
               currentLiabilities += a.balance
            }
         }
      }
   }
   
   func fetchAccounts() -> [AccountEntity] {
      let container = NSPersistentContainer(name: "MyBudget")
      container.loadPersistentStores { description, error in
         if let error = error {
            print("ERROR LOADING CORE DATA. \(error)")
         }
      }
      
      var allAccounts = [AccountEntity]()
      let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountEntity")
      let accountSort = NSSortDescriptor(key: "userOrder", ascending: true)

      fetchRequest.sortDescriptors = [accountSort]
      
      do {
         allAccounts = try container.viewContext.fetch(fetchRequest) as! Array
      }
      catch {
         let nserror = error as NSError
         print("Unresolved error \(nserror), \(nserror.userInfo)")
      }
      return allAccounts
   }
   
}

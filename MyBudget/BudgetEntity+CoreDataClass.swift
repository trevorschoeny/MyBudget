//
//  BudgetEntity+CoreDataClass.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//
//

import Foundation
import CoreData

@objc(BudgetEntity)
public class BudgetEntity: NSManagedObject {
   
   public var periodArray: [PeriodEntity] {
      let set = period as? Set<PeriodEntity> ?? []
      return set.sorted {
         $0.wDate < $1.wDate
      }
   }
   
   public var transactionArray: [TransactionEntity] {
      let set = transaction as? Set<TransactionEntity> ?? []
      return set.sorted {
         $0.wDate < $1.wDate
      }
   }
   
   public var wDate: Date {
      date ?? Date()
   }
   public var wName: String {
      name ?? "No Account"
   }
   public var wNotes: String {
      notes ?? "No Notes"
   }

}

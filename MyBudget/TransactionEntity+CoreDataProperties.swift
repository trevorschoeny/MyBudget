//
//  TransactionEntity+CoreDataProperties.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//
//

import Foundation
import CoreData


extension TransactionEntity {
   
   @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
      return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
   }
   
   @NSManaged public var amount: Double
   @NSManaged public var date: Date?
   @NSManaged public var isDebit: Bool
   @NSManaged public var name: String?
   @NSManaged public var notes: String?
   @NSManaged public var account: AccountEntity?
   @NSManaged public var budget: BudgetEntity?
   
   public var wDate: Date {
      date ?? Date()
   }
   public var wName: String {
      name ?? "No Name"
   }
   public var wNotes: String {
      notes ?? "No Notes"
   }
   
}

extension TransactionEntity : Identifiable {
   
}

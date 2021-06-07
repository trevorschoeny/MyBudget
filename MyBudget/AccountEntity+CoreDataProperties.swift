//
//  AccountEntity+CoreDataProperties.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//
//

import Foundation
import CoreData


extension AccountEntity {
   
   @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountEntity> {
      return NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
   }
   
   @NSManaged public var balance: Double
   @NSManaged public var date: Date?
   @NSManaged public var isCurrent: Bool
   @NSManaged public var isDebit: Bool
   @NSManaged public var name: String?
   @NSManaged public var notes: String?
   @NSManaged public var onDashboard: Bool
   @NSManaged public var userOrder: Int16
   @NSManaged public var transaction: NSSet?
   
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

// MARK: Generated accessors for transaction
extension AccountEntity {
   
   @objc(addTransactionObject:)
   @NSManaged public func addToTransaction(_ value: TransactionEntity)
   
   @objc(removeTransactionObject:)
   @NSManaged public func removeFromTransaction(_ value: TransactionEntity)
   
   @objc(addTransaction:)
   @NSManaged public func addToTransaction(_ values: NSSet)
   
   @objc(removeTransaction:)
   @NSManaged public func removeFromTransaction(_ values: NSSet)
   
}

extension AccountEntity : Identifiable {
   
}

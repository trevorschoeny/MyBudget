//
//  AccountEntity+CoreDataClass.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//
//

import Foundation
import CoreData

@objc(AccountEntity)
public class AccountEntity: NSManagedObject {
   
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

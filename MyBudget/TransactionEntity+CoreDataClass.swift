//
//  TransactionEntity+CoreDataClass.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//
//

import Foundation
import CoreData

@objc(TransactionEntity)
public class TransactionEntity: NSManagedObject {
   
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

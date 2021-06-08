//
//  SubscriptionEntity+CoreDataClass.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/8/21.
//
//

import Foundation
import CoreData

@objc(SubscriptionEntity)
public class SubscriptionEntity: NSManagedObject {
   
   public var wBillDate: Date {
      billDate ?? Date()
   }
   public var wName: String {
      name ?? ""
   }
   public var wNotes: String {
      notes ?? ""
   }

}

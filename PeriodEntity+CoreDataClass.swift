//
//  PeriodEntity+CoreDataClass.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//
//

import Foundation
import CoreData

@objc(PeriodEntity)
public class PeriodEntity: NSManagedObject {
   
   public var wDate: Date {
      date ?? Date()
   }

}

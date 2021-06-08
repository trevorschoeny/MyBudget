//
//  BudgetEntity+CoreDataProperties.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//
//

import Foundation
import CoreData


extension BudgetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetEntity> {
        return NSFetchRequest<BudgetEntity>(entityName: "BudgetEntity")
    }

    @NSManaged public var balance: Double
    @NSManaged public var budgetAmount: Double
    @NSManaged public var date: Date?
    @NSManaged public var extraAmount: Double
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var onDashboard: Bool
    @NSManaged public var userOrder: Int16
    @NSManaged public var transaction: NSSet?
    @NSManaged public var period: NSSet?

}

// MARK: Generated accessors for transaction
extension BudgetEntity {

    @objc(addTransactionObject:)
    @NSManaged public func addToTransaction(_ value: TransactionEntity)

    @objc(removeTransactionObject:)
    @NSManaged public func removeFromTransaction(_ value: TransactionEntity)

    @objc(addTransaction:)
    @NSManaged public func addToTransaction(_ values: NSSet)

    @objc(removeTransaction:)
    @NSManaged public func removeFromTransaction(_ values: NSSet)

}

// MARK: Generated accessors for period
extension BudgetEntity {

    @objc(addPeriodObject:)
    @NSManaged public func addToPeriod(_ value: PeriodEntity)

    @objc(removePeriodObject:)
    @NSManaged public func removeFromPeriod(_ value: PeriodEntity)

    @objc(addPeriod:)
    @NSManaged public func addToPeriod(_ values: NSSet)

    @objc(removePeriod:)
    @NSManaged public func removeFromPeriod(_ values: NSSet)

}

extension BudgetEntity : Identifiable {

}

//
//  TempBudget.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import Foundation

struct TempBudget {
   var balance = ""
   var budgetAmount = ""
   var date = Date()
   var extraAmount = ""
   var name = ""
   var notes = ""
   var onDashboard = false
   var userOrder: Int16 = 1000
   var periods: [PeriodEntity]?
   
   var diffStartBalance = false
   var isExtraFunds = false
   
   func populateBudget(budget: BudgetEntity) {
      if !diffStartBalance {
         budget.balance = Double(budgetAmount) ?? 0.0
         budget.balance += Double(extraAmount) ?? 0.0
      } else {
         budget.balance = Double(balance) ?? 0.0
      }
      budget.budgetAmount = Double(budgetAmount) ?? 0.0
      budget.date = Date()
      if !isExtraFunds {
         budget.extraAmount = 0
      } else {
         budget.extraAmount = Double(extraAmount) ?? 0.0
      }
      budget.name = name
      budget.notes = notes
      budget.onDashboard = onDashboard
      budget.userOrder = 1000
//      budget.addToPeriod(<#T##value: PeriodEntity##PeriodEntity#>)
   }
   mutating func prepare(budget: BudgetEntity) {
      balance = String(budget.balance)
      budgetAmount = String(budget.budgetAmount)
      date = budget.date ?? Date()
      extraAmount = String(budget.extraAmount)
      name = budget.wName
      notes = budget.wNotes
      onDashboard = budget.onDashboard
      userOrder = budget.userOrder
      periods = budget.periodArray
   }
   mutating func prepareNew(budget: BudgetEntity) {
      date = budget.date ?? Date()
      notes = budget.wNotes
      onDashboard = budget.onDashboard
      userOrder = budget.userOrder
      periods = budget.periodArray
   }
   
}

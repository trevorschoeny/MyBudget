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
   }
   func updateBudget(budget: BudgetEntity, oldBudget: TempBudget) {
      if balance != "" {
         budget.balance = Double(balance) ?? 0.0
      } else {
         budget.balance = Double(oldBudget.balance) ?? 0.0
      }
      if budgetAmount != "" {
         budget.budgetAmount = Double(budgetAmount) ?? 0.0
      } else {
         budget.budgetAmount = Double(oldBudget.budgetAmount) ?? 0.0
      }
      budget.date = date
      if extraAmount != "" {
         budget.extraAmount = Double(extraAmount) ?? 0.0
      } else {
         budget.extraAmount = Double(oldBudget.extraAmount) ?? 0.0
      }
      if name != "" {
         budget.name = name
      } else {
         budget.name = oldBudget.name
      }
      budget.notes = notes
      budget.onDashboard = onDashboard
      
      if !isExtraFunds {
         budget.extraAmount = 0
      }
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
      balance = ""
      budgetAmount = ""
      date = budget.date ?? Date()
      extraAmount = ""
      name = ""
      notes = budget.wNotes
      onDashboard = budget.onDashboard
      userOrder = budget.userOrder
      periods = budget.periodArray
   }
   
}

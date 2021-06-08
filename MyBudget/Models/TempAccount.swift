//
//  TempAccount.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import Foundation

struct TempAccount {
   var balance = ""
   var date = Date()
   var isDebit = true
   var isCurrent = true
   var name = ""
   var notes = ""
   var onDashboard = false
   var userOrder: Int16 = 1000
   
   func populateAccount(account: AccountEntity) {
      account.balance = Double(balance) ?? 0.0
      if !isDebit {
         account.balance *= -1
      }
      account.date = Date()
      account.isDebit = isDebit
      account.isCurrent = isCurrent
      account.name = name
      account.notes = notes
      account.onDashboard = onDashboard
      account.userOrder = 1000
   }
   func updateAccount(account: AccountEntity, oldAccount: TempAccount) {
      if balance != "" {
         account.balance = Double(balance) ?? 0.0
      } else {
         account.balance = Double(oldAccount.balance) ?? 0.0
      }
      if !isDebit {
         account.balance *= -1
      }
      account.date = date
      account.isDebit = isDebit
      account.isCurrent = isCurrent
      if name != "" {
         account.name = name
      } else {
         account.name = oldAccount.name
      }
      account.notes = notes
      account.onDashboard = onDashboard
      account.userOrder = userOrder
   }
   mutating func prepare(account: AccountEntity) {
      balance = String(account.balance)
      date = account.date ?? Date()
      isDebit = account.isDebit
      isCurrent = account.isCurrent
      name = account.name.bound
      notes = account.notes.bound
      onDashboard = account.onDashboard
      userOrder = account.userOrder
   }
   mutating func prepareNew(account: AccountEntity) {
      balance = ""
      date = account.date ?? Date()
      isDebit = account.isDebit
      isCurrent = account.isCurrent
      name = ""
      notes = account.notes.bound
      onDashboard = account.onDashboard
      userOrder = account.userOrder
   }

}

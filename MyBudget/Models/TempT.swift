//
//  NewTransaction.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/6/21.
//

import Foundation

struct TempT {
   var account: AccountEntity?
   var amount: String?
   var budget: BudgetEntity?
   var date: Date = Date()
   var isDebit = false
   var name: String?
   var notes: String?
   
   mutating func reset() {
      account = nil
      amount = nil
      budget = nil
      date = Date()
      isDebit = false
      name = nil
      notes = nil
   }
   func populateT(transaction: TransactionEntity) {
      transaction.account = account?.name
      transaction.amount = Double(amount ?? "") ?? 0.0
      transaction.budget = budget?.name
      transaction.date = Date()
      transaction.isDebit = isDebit
      transaction.name = name
      transaction.notes = notes
   }
}

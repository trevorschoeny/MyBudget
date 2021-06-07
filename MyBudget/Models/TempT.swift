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
   func populateT(transaction: TransactionEntity, oldTransaction: TempT) {
      transaction.account = account?.name
      if amount == "" {
         transaction.amount = Double(oldTransaction.amount ?? "") ?? 0.0
      } else {
         transaction.amount = Double(amount ?? "") ?? 0.0
      }
      transaction.budget = budget?.name
      transaction.date = date
      transaction.isDebit = isDebit
      if name == "" {
         transaction.name = oldTransaction.name
      } else {
         transaction.name = name
      }
      transaction.notes = notes
   }
   mutating func prepareTempT(transaction: TransactionEntity) {
      account?.name = transaction.account
      amount = String(transaction.amount)
      budget?.name = transaction.budget
      date = transaction.date ?? Date()
      isDebit = transaction.isDebit
      name = transaction.name
      notes = transaction.notes
   }
   mutating func prepareTempTNew(transaction: TransactionEntity) {
      account?.name = transaction.account
      amount = ""
      budget?.name = transaction.budget
      date = transaction.date ?? Date()
      isDebit = transaction.isDebit
      name = ""
      notes = transaction.notes
   }
}

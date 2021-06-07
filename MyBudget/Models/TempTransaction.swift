//
//  TempTransaction.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import Foundation

struct TempTransaction {
   var amount = ""
   var date = Date()
   var isDebit = false
   var name = ""
   var notes = ""
   var account: AccountEntity?
   var budget: BudgetEntity?
   
   func populateTransaction(transaction: TransactionEntity) {
      transaction.amount = Double(amount) ?? 0.0
      if !isDebit {
         transaction.amount *= -1
      }
      transaction.date = date
      transaction.isDebit = isDebit
      transaction.name = name
      transaction.notes = notes
      transaction.account = account
      transaction.budget = budget
   }
   func updateTransaction(transaction: TransactionEntity, oldTransaction: TempTransaction) {
      if amount == "" {
         transaction.amount = Double(oldTransaction.amount) ?? 0.0
      } else {
         transaction.amount = Double(amount) ?? 0.0
         if !transaction.isDebit {
            transaction.amount *= -1
         }
      }
      transaction.date = date
      transaction.isDebit = isDebit
      if name == "" {
         transaction.name = oldTransaction.name
      } else {
         transaction.name = name
      }
      transaction.notes = notes
      transaction.account = account
      transaction.budget = budget
   }
   mutating func prepare(transaction: TransactionEntity) {
      var tempAmount = transaction.amount
      if !transaction.isDebit && transaction.amount != 0.0 {
         tempAmount *= -1
      }
      amount = String(tempAmount)
      date = transaction.wDate
      isDebit = transaction.isDebit
      name = transaction.wName
      notes = transaction.wNotes
      account = transaction.account
      budget = transaction.budget
   }
   mutating func prepareNew(transaction: TransactionEntity) {
      amount = ""
      date = transaction.wDate
      isDebit = transaction.isDebit
      name = ""
      notes = transaction.wNotes
      account = transaction.account
      budget = transaction.budget
   }
}

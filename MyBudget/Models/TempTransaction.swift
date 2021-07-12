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
//    var isDebit = false
    var name = ""
    var notes = ""
    var account: AccountEntity?
    var account2: AccountEntity?
    var budget: BudgetEntity?
    var budget2: BudgetEntity?
    
    func populateTransaction(transaction: TransactionEntity) {
        transaction.amount = Double(amount) ?? 0.0
        transaction.date = date
        transaction.name = name
        transaction.notes = notes
        transaction.account = account
        transaction.account2 = account2
        transaction.budget = budget
        transaction.budget2 = budget2
    }
    func updateTransaction(transaction: TransactionEntity, oldTransaction: TempTransaction) {
        if amount == "" {
            transaction.amount = (Double(oldTransaction.amount) ?? 0.0)
        } else {
            transaction.amount = Double(amount) ?? 0.0
        }
        transaction.date = date
        if name == "" {
            transaction.name = oldTransaction.name
        } else {
            transaction.name = name
        }
        transaction.notes = notes
        transaction.account = account
        transaction.account2 = account2
        transaction.budget = budget
        transaction.budget2 = budget2
    }
    mutating func prepare(transaction: TransactionEntity) {
        amount = String(transaction.amount)
        date = transaction.wDate
        name = transaction.wName
        notes = transaction.wNotes
        account = transaction.account
        account2 = transaction.account2
        budget = transaction.budget
        budget2 = transaction.budget2
    }
    mutating func prepareNew(transaction: TransactionEntity) {
        amount = ""
        date = transaction.wDate
        name = ""
        notes = transaction.wNotes
        account = transaction.account
        account2 = transaction.account2
        budget = transaction.budget
        budget2 = transaction.budget2
    }
}

//
//  TempSubscription.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/8/21.
//

import Foundation

struct TempSubscription {
   var amount = ""
   var billDate = Date()
   var isMonthly = true
   var name = ""
   var notes = ""
   var account: AccountEntity?
   var budget: BudgetEntity?
   
   func populateSubscription(subscription: SubscriptionEntity) {
      subscription.amount = Double(amount) ?? 0.0
      subscription.billDate = billDate
      subscription.isMonthly = isMonthly
      subscription.name = name
      subscription.notes = notes
      subscription.account = account
      subscription.budget = budget
   }
   func updateSubscription(subscription: SubscriptionEntity, oldSubscription: TempSubscription) {
      if amount != "" {
         subscription.amount = Double(amount) ?? 0.0
      } else {
         subscription.amount = Double(oldSubscription.amount) ?? 0.0
      }
      subscription.billDate = billDate
      subscription.isMonthly = isMonthly
      if name != "" {
         subscription.name = name
      } else {
         subscription.name = oldSubscription.name
      }
      subscription.notes = notes
      subscription.account = account
      subscription.budget = budget
   }
   mutating func prepare(subscription: SubscriptionEntity) {
      amount = String(subscription.amount)
      billDate = subscription.wBillDate
      isMonthly = subscription.isMonthly
      name = subscription.wName
      notes = subscription.wNotes
      account = subscription.account
      budget = subscription.budget
   }
   mutating func prepareNew(subscription: SubscriptionEntity) {
      amount = ""
      billDate = subscription.wBillDate
      isMonthly = subscription.isMonthly
      name = ""
      notes = subscription.wNotes
      account = subscription.account
      budget = subscription.budget
   }
}

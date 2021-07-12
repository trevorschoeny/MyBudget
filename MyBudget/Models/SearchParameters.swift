//
//  SearchParameters.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/6/21.
//

import Foundation

struct SearchParameters {
   var text: String?
   var account: AccountEntity?
   var budget: BudgetEntity?
   var firstDate: Date
   var secondDate: Date
   var dateToggle = false
   var dateRangeToggle = false
   
   init() {
      firstDate = Date()
      secondDate = Date()
   }
   
   func isFiltering() -> Bool {
      if text == nil &&
            account == nil &&
            budget == nil &&
            dateToggle == false &&
            dateRangeToggle == false {
         return false
      }
      return true
   }
   
   mutating func reset() {
      text = nil
      account = nil
      budget = nil
      firstDate = Date()
      secondDate = Date()
      dateToggle = false
      dateRangeToggle = false
   }
}

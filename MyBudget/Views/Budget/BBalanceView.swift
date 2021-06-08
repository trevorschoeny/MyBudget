//
//  BBalanceView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct BBalanceView: View {
   @ObservedObject var budget: BudgetEntity
    var body: some View {
      HStack {
         Spacer()
         VStack {
            if budget.balance < 0 {
               Text(formatterFunction(number: budget.balance))
                  .foregroundColor(.red)
                  .fontWeight(.semibold)
            }
            else if budget.balance == 0 {
               Text(formatterFunction(number: budget.balance))
                  .foregroundColor(.red)
                  .fontWeight(.semibold)
            }
            else if budget.balance <= (budget.budgetAmount * 0.25) {
               Text(formatterFunction(number: budget.balance))
                  .foregroundColor(.orange)
                  .fontWeight(.semibold)
            }
            else if budget.balance <= (budget.budgetAmount * 0.5) {
               Text(formatterFunction(number: budget.balance))
                  .foregroundColor(.yellow)
                  .fontWeight(.semibold)
            }
            else {
               Text(formatterFunction(number: budget.balance))
                  .foregroundColor(.green)
                  .fontWeight(.semibold)
            }
            HStack(spacing: 0) {
               Text("left of ")
                  .foregroundColor(.gray)
                  .font(.body)
                  .offset(y: 1.3)
               Text(formatterFunction(number: budget.budgetAmount))
                  .foregroundColor(.gray)
                  .font(.title2)
            }
            if budget.extraAmount != 0 {
               HStack(spacing: 0) {
                  Text("with ")
                     .offset(y: 1.3)
                  Text("$" + String(budget.extraAmount))
                     .font(.body)
                  Text(" extra funds.")
                     .offset(y: 1.4)
               }
               .foregroundColor(.gray)
               .font(.footnote)
            }
         }
         .font(.largeTitle)
         .padding(.vertical)
         Spacer()
      }
    }
}

//struct BBalanceView_Previews: PreviewProvider {
//    static var previews: some View {
//        BBalanceView()
//    }
//}

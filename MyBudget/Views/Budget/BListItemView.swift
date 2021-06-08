//
//  BListItemView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct BListItemView: View {
   @ObservedObject var b: BudgetEntity
    var body: some View {
      NavigationLink(destination: BDetailView(budget: b)) {
         HStack(spacing: 0) {
            Text(b.name ?? "No Name")
            Spacer()
            if b.balance < 0 {
               Text(formatterFunction(number: b.balance))
                  .foregroundColor(.red)
            }
            else if b.balance == 0 {
               Text(formatterFunction(number: b.balance))
                  .foregroundColor(.red)
            }
            else if b.balance <= (b.budgetAmount * 0.25) {
               Text(formatterFunction(number: b.balance))
                  .foregroundColor(.orange)
            }
            else if b.balance <= (b.budgetAmount * 0.5) {
               Text(formatterFunction(number: b.balance))
                  .foregroundColor(.yellow)
            }
            else {
               Text(formatterFunction(number: b.balance))
                  .foregroundColor(.green)
            }
            Text(" left of ")
               .foregroundColor(.gray)
               .font(.footnote)
               .offset(y: 2)
            Text(formatterFunction(number: b.budgetAmount + b.extraAmount))
         }
      }
    }
}

//struct BListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        BListItemView()
//    }
//}

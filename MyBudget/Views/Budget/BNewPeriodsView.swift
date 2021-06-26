//
//  BNewPeriodsView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/21/21.
//

import SwiftUI

struct BNewPeriodsView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.userOrder, ascending: true), NSSortDescriptor(keyPath: \BudgetEntity.date, ascending: true)], animation: .default)
   private var budgets: FetchedResults<BudgetEntity>
   
   @State var budgetsNewPeriod: [Bool] = []
   @State var showingPeriodPopover = false
   
   var body: some View {
      VStack {
         List {
            ForEach(0..<budgets.count) { i in
               if budgets[i].isRetired == false {
//                  Toggle(isOn: $budgetsNewPeriod[i]) {
//                     Text(budgets[i].wName)
//                  }
               }
            }
         }
         Button(action: {
            showingPeriodPopover = true
         }, label: {
            ZStack {
               Rectangle()
                  .font(.headline)
                  .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                  .frame(height: 55)
                  .cornerRadius(10)
                  .padding(.horizontal)
               Text("New Period")
                  .font(.headline)
                  .foregroundColor(.white)
            }
         })
         .padding(.bottom, 10)
         .popover(isPresented: $showingPeriodPopover, content: {
            BNewPeriodView(budgetsNewPeriod: budgetsNewPeriod)
         })
      }
      .onAppear {
         for _ in 0..<budgets.count {
            budgetsNewPeriod.append(true)
         }
      }
   }
}

struct BNewPeriodsView_Previews: PreviewProvider {
   static var previews: some View {
      BNewPeriodsView()
   }
}

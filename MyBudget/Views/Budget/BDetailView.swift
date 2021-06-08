//
//  BDetailView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct BDetailView: View {
   @State var budget: BudgetEntity
   @State var oldBudget = TempBudget()
   @State var newBudget = TempBudget()
   
   @State var showingPopover = false
   @State var showingFundPopover = false
   @State var showAlert = false
   
   var body: some View {
      VStack {
         List {
            
            // MARK: Description
            VStack(alignment: .leading) {
               Text(budget.name ?? "No Name")
                  .font(.largeTitle)
                  .multilineTextAlignment(.leading)
               // MARK: Date
               HStack(spacing: 0) {
                  Text("Created on ")
                     .foregroundColor(.gray)
                  Text(budget.date ?? Date(), style: .date)
                     .foregroundColor(.gray)
               }
               .font(.footnote)
            }
            .padding(.vertical, 5.0)
            
            // MARK: Balance & Budget Amount
            BBalanceView(budget: budget)
            
            // MARK: Notes
            VStack(alignment: .leading) {
               Text("Notes:")
                  .foregroundColor(Color.gray)
                  .padding(.vertical, 6.0)
               if budget.notes != "" && budget.notes != nil {
                  Text(budget.notes ?? "")
                     .multilineTextAlignment(.leading)
                     .padding(.bottom, 6.0)
               }
            }
         }
         .popover(isPresented: self.$showingFundPopover, content: {
            BNewPeriodView(inputBudget: budget)
         })
         .listStyle(InsetGroupedListStyle())
         
         // MARK: New Period
         VStack {
            Button(action: {
               showAlert = true
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
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Would you like to start a new period for " + budget.name! + "?"),
                     primaryButton: .default(Text("Yes")) {
                        print("HERE")
                        showingFundPopover = true
                     },
                     secondaryButton: .cancel())
            })
            .popover(isPresented: self.$showingPopover, content: {
               BEditView(oldBudget: $oldBudget, newBudget: $newBudget, inputBudget: $budget)
            })
         }
      }
      .navigationBarItems(trailing: editButton)
      .navigationTitle("Budget")
   }
   private var editButton: some View {
      Button(action: {
         oldBudget.prepare(budget: budget)
         newBudget.prepareNew(budget: budget)
         showingPopover = true
      }, label: {
         Text("Edit")
            .foregroundColor(.blue)
      })
   }
}

//struct BudgetDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BDetailView()
//    }
//}

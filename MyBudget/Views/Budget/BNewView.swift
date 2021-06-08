//
//  BNewView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct BNewView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.date, ascending: true)], animation: .default)
   private var budgets: FetchedResults<BudgetEntity>
   
   @State var newBudget = TempBudget()
   @Environment(\.presentationMode) var isPresented
   @State var showAlert = false
   @State var diffStartBalance = false
   @State var isExtraFunds = false
   
    var body: some View {
      NavigationView {
         VStack {
            
            Form {
               // MARK: Name
               TextField("Add budget name here...", text: $newBudget.name)
               
               // MARK: onDashboard
               Toggle("Include on Dashboard", isOn: $newBudget.onDashboard)
               
               // MARK: Budget Amount
               HStack {
                  Text("$ ")
                  TextField("Budget Amount", text: $newBudget.budgetAmount)
                     .keyboardType(.decimalPad)
               }
               
               // MARK: Different Starting Balance?
               Toggle("Custom Starting Balance?", isOn: $diffStartBalance)
               
               // MARK: Balance
               if diffStartBalance {
                  HStack {
                     Text("$ ")
                     TextField("Starting Balance", text: $newBudget.balance)
                        .keyboardType(.decimalPad)
                  }
               }
               
               // MARK: Add Extra Funds?
               Toggle("Add Extra Funds? (For this period only)", isOn: $isExtraFunds)
               
               // MARK: Extra Funds
               if isExtraFunds {
                  HStack {
                     Text("$ ")
                     TextField("Extra Funds", text: $newBudget.extraAmount)
                        .keyboardType(.decimalPad)
                  }
               }
               
               //MARK: Notes
               VStack(alignment: .leading, spacing: 0.0) {
                  Text("Notes: ")
                     .padding(.top, 5.0)
                  TextEditor(text: $newBudget.notes)
               }
            }
            
            // MARK: Cancel Button
            Button(action: {
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Save Button
            Button(action: {
               if newBudget.name == "" ||  newBudget.budgetAmount.filter({ $0 == "."}).count > 1 {
                  showAlert = true
               }
               // Save Account
               else {
                  newBudget.diffStartBalance = diffStartBalance
                  newBudget.isExtraFunds = isExtraFunds
                  newBudget.populateBudget(budget: BudgetEntity(context: viewContext))
                  do {
                      try viewContext.save()
                  } catch {
                      let nsError = error as NSError
                      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                  }
                  self.isPresented.wrappedValue.dismiss()
               }
               
            }, label: {
               ZStack {
                  Rectangle()
                     .font(.headline)
                     .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                     .frame(height: 55)
                     .cornerRadius(10)
                     .padding(.horizontal)
                  Text("Add")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            })
            .padding(.bottom)
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Invalid Entry"), message: Text("Please enter a valid input."), dismissButton: .default(Text("Ok")))
            })
         }
         .navigationTitle("Add Budget")
      }
    }
}

struct BNewView_Previews: PreviewProvider {
    static var previews: some View {
        BNewView()
    }
}

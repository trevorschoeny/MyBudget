//
//  BEditView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct BEditView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @Binding var oldBudget: TempBudget
   @Binding var newBudget: TempBudget
   @Binding var inputBudget: BudgetEntity
   
   @State var showAlert = false
   @Environment(\.presentationMode) var isPresented
   @State var diffStartBalance = false
   @State var isExtraFunds = false
   
    var body: some View {
      NavigationView {
         VStack {
            
            Form {
               // MARK: Name
               TextField(oldBudget.name, text: $newBudget.name)
               
               // MARK: onDashboard
               Toggle("Include on Dashboard", isOn: $newBudget.onDashboard)
               
               
               // MARK: Budget Amount
               HStack {
                  Text("Budget: ")
                  Text("$ ")
                  TextField(oldBudget.budgetAmount, text: $newBudget.budgetAmount)
                     .keyboardType(.decimalPad)
               }
               
               // MARK: Balance
               HStack {
                  Text("Balance: ")
                  Text("$ ")
                  TextField(oldBudget.balance, text: $newBudget.balance)
                     .keyboardType(.decimalPad)
               }
               
               // MARK: Add Extra Funds?
               Toggle("Add Extra Funds? (For this period only)", isOn: $isExtraFunds)
               
               // MARK: Extra Funds
               if isExtraFunds {
                  HStack {
                     Text("Extra Funds: $ ")
                     TextField(oldBudget.extraAmount, text: $newBudget.extraAmount)
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
               newBudget.prepareNew(budget: inputBudget)
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Save Button
            Button(action: {
               if newBudget.budgetAmount.filter({ $0 == "."}).count > 1 && newBudget.balance.filter({ $0 == "."}).count > 1{
                  showAlert = true
               }
               // Update Budget
               else {
                  oldBudget.isExtraFunds = isExtraFunds
                  newBudget.isExtraFunds = isExtraFunds
                  
                  newBudget.updateBudget(budget: inputBudget, oldBudget: oldBudget)
                  
                  do {
                     try viewContext.save()
                  } catch {
                     let nsError = error as NSError
                     fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                  }
                  
                  oldBudget.prepare(budget: inputBudget)
                  newBudget.prepareNew(budget: inputBudget)
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
                  Text("Update")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            })
            .padding(.bottom)
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Invalid Entry"), message: Text("Please enter a valid input."), dismissButton: .default(Text("Ok")))
            })
         }
         .navigationTitle("Edit Budget")
      }
    }
}

//struct BEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        BEditView()
//    }
//}

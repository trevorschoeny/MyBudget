//
//  TEdit.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct TEdit: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: TransactionEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.name, ascending: true)], animation: .default)
   private var transactions: FetchedResults<TransactionEntity>
   
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.name, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
   @FetchRequest(
      entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.name, ascending: true)], animation: .default)
   private var budgets: FetchedResults<BudgetEntity>
   
   @Binding var oldT: TempT
   @Binding var newT: TempT
   @Binding var inputTransaction: TransactionEntity
   @Environment(\.presentationMode) var isPresented
   @State var showAlert = false
   
   
    var body: some View {
      NavigationView {
         VStack {
            Form {
               // MARK: Description
               TextField(oldT.name.bound, text: $newT.name.bound)
               
               // MARK: Date
               DatePicker("Date of Transaction: ", selection: $newT.date, displayedComponents: .date)
               
               VStack(alignment: .leading) {
                  // MARK: Debit or Credit
                  HStack(spacing: 0) {
                     if newT.isDebit {
                        Text("Debit to . . .")
                     }
                     else {
                        Text("Credit from . . .")
                     }
                     // MARK: Account
                     Picker(selection: $newT.account, label: Text("")) {
                        ForEach(accounts) { a in
                           Text(a.name ?? "no name").tag(a as AccountEntity?)
                        }
                     }
                     .lineLimit(1)
                     Spacer()
                     if newT.isDebit {
                        Toggle("", isOn: $newT.isDebit)
                           .frame(width: 60)
                     }
                     else {
                        Toggle("", isOn: $newT.isDebit)
                           .frame(width: 60)
                     }
                  }
               }
               
               // MARK: Amount
               HStack {
                  Text("Amount: ")
                  if !newT.isDebit {
                     Text("$( ")
                     TextField(oldT.amount.bound, text: $newT.amount.bound)
                        .keyboardType(.decimalPad)
                     Spacer()
                     Text(" )")
                  }
                  else {
                     Text("$ ")
                     TextField(oldT.amount.bound, text: $newT.amount.bound)
                        .keyboardType(.decimalPad)
                  }
               }
               
               // MARK: Budget
               if !newT.isDebit {
                  HStack {
                     Text("Budget:")
                     Picker(selection: $newT.budget, label: Text("")) {
                        ForEach(budgets) { b in
                           Text(b.name ?? "no name").tag(b as BudgetEntity?)
                        }
                        .lineLimit(1)
                     }
                  }
               }
               
               // MARK: Remove Budget
               if newT.budget != nil {
                  HStack {
                     Spacer()
                     Button(action: {
                        newT.budget = nil
                     }, label: {
                        Text("Clear Budget")
                           .foregroundColor(.blue)
                     })
                     Spacer()
                  }
                  
               }
               
               //MARK: Notes
               VStack(alignment: .leading, spacing: 0.0) {
                  Text("Notes: ")
                     .padding(.top, 5.0)
                  
                  TextEditor(text: $newT.notes.bound)
               }
            }
            
            // MARK: Cancel Button
            Button(action: {
               newT.reset()
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Save Button
            Button(action: {

               // Show Alert
               if (newT.amount?.filter({ $0 == "."}).count)! > 1 || newT.account == nil {
                  showAlert = true
               }
               // Submit Transaction
               else {
                  newT.populateT(transaction: inputTransaction, oldTransaction: oldT)
                  do {
                      try viewContext.save()
                  } catch {
                      let nsError = error as NSError
                      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                  }
//                  updateAccountBalance()
                  if !inputTransaction.isDebit {
//                     updateBudgetBalance()
                  }
                  oldT = newT
                  newT.prepareTempTNew(transaction: inputTransaction)
               }
               self.isPresented.wrappedValue.dismiss()

            }, label: {
               ZStack {
                  Rectangle()
                     .font(.headline)
                     .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                     .frame(height: 55)
                     .cornerRadius(10)
                     .padding(.horizontal)
                  Text("Save")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            })
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Invalid Entries"), message: Text("Please enter a valid input for each entry."), dismissButton: .default(Text("Ok")))
            })
            .font(.headline)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
            .cornerRadius(10)
            .padding([.leading, .bottom, .trailing])
         }
         .navigationTitle("Edit Transaction")
      }
    }
}

//struct TEdit_Previews: PreviewProvider {
//    static var previews: some View {
//        TEdit()
//    }
//}

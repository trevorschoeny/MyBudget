//
//  TEditView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct TEditView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.userOrder, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
   @FetchRequest(
      entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.userOrder, ascending: true)], animation: .default)
   private var budgets: FetchedResults<BudgetEntity>
   
   @Binding var oldTransaction: TempTransaction
   @Binding var newTransaction: TempTransaction
   @Binding var inputTransaction: TransactionEntity
   @Environment(\.presentationMode) var isPresented
   @State var showAlert = false
   
   
   var body: some View {
      NavigationView {
         VStack {
            Form {
               // MARK: Description
               TextField(oldTransaction.name, text: $newTransaction.name)
               
               // MARK: Date
               DatePicker("Date of Transaction: ", selection: $newTransaction.date, displayedComponents: .date)
               
               VStack(alignment: .leading) {
                  // MARK: Debit or Credit
                  HStack(spacing: 0) {
                     if newTransaction.isDebit {
                        Text("Debit to . . .")
                     }
                     else {
                        Text("Credit from . . .")
                     }
                     // MARK: Account
                     Picker(selection: $newTransaction.account, label: Text("")) {
                        ForEach(accounts) { a in
                           Text(a.name ?? "no name").tag(a as AccountEntity?)
                        }
                     }
                     .lineLimit(1)
                     Spacer()
                     if newTransaction.isDebit {
                        Toggle("", isOn: $newTransaction.isDebit)
                           .frame(width: 60)
                     }
                     else {
                        Toggle("", isOn: $newTransaction.isDebit)
                           .frame(width: 60)
                     }
                  }
               }
               
               // MARK: Amount
               HStack {
                  Text("Amount: ")
                  if !newTransaction.isDebit {
                     Text("$( ")
                     TextField(oldTransaction.amount, text: $newTransaction.amount)
                        .keyboardType(.decimalPad)
                     Spacer()
                     Text(" )")
                  }
                  else {
                     Text("$ ")
                     TextField(oldTransaction.amount, text: $newTransaction.amount)
                        .keyboardType(.decimalPad)
                  }
               }
               
               // MARK: Budget
               if !newTransaction.isDebit {
                  HStack {
                     Text("Budget:")
                     Picker(selection: $newTransaction.budget, label: Text("")) {
                        ForEach(budgets) { b in
                           Text(b.name ?? "no name").tag(b as BudgetEntity?)
                        }
                        .lineLimit(1)
                     }
                  }
               }
               
               // MARK: Clear Budget
               if !newTransaction.isDebit && newTransaction.budget != nil {
                  HStack {
                     Spacer()
                     Button(action: {
                        newTransaction.budget = nil
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
                  
                  TextEditor(text: $newTransaction.notes)
               }
            }
            
            // MARK: Cancel Button
            Button(action: {
               newTransaction.prepareNew(transaction: inputTransaction)
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Save Button
            Button(action: {
               
               // Show Alert
               if (newTransaction.amount.filter({ $0 == "."}).count) > 1 || newTransaction.account == nil {
                  showAlert = true
               }
               // Submit Transaction
               else {
                  newTransaction.updateTransaction(transaction: inputTransaction, oldTransaction: oldTransaction)
                  updateAccountBalance()
                  updateBudgetBalance()
                  
                  do {
                     try viewContext.save()
                  } catch {
                     let nsError = error as NSError
                     fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                  }
                  
                  oldTransaction.prepare(transaction: inputTransaction)
                  newTransaction.prepareNew(transaction: inputTransaction)
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
   private func updateAccountBalance() {
      
      if !oldTransaction.isDebit {
         oldTransaction.account?.balance += Double(oldTransaction.amount) ?? 0.0
      } else {
         oldTransaction.account?.balance -= Double(oldTransaction.amount) ?? 0.0
      }
      
      if newTransaction.amount == "" {
         newTransaction.amount = oldTransaction.amount
      }
      
      if !newTransaction.isDebit {
         newTransaction.account?.balance -= Double(newTransaction.amount) ?? 0.0
      } else {
         newTransaction.account?.balance += Double(newTransaction.amount) ?? 0.0
      }
   }
   private func updateBudgetBalance() {
      
      if !oldTransaction.isDebit {
         oldTransaction.budget?.balance += Double(oldTransaction.amount) ?? 0.0
      }
      
      if newTransaction.amount == "" {
         newTransaction.amount = oldTransaction.amount
      }
      
      if !newTransaction.isDebit {
         newTransaction.budget?.balance -= Double(oldTransaction.amount) ?? 0.0
      }
   }
}

//struct TEdit_Previews: PreviewProvider {
//    static var previews: some View {
//        TEdit()
//    }
//}

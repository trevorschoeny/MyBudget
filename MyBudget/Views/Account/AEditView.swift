//
//  AEditView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct AEditView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @Binding var oldAccount: TempAccount
   @Binding var newAccount: TempAccount
   @Binding var inputAccount: AccountEntity
   
   @State var showAlert = false
   @Environment(\.presentationMode) var isPresented
   
    var body: some View {
      NavigationView {
         VStack {
            
            Form {
               // MARK: Name
               TextField(oldAccount.name, text: $newAccount.name)
               
               // MARK: onDashboard
               Toggle("Include on Dashboard", isOn: $newAccount.onDashboard)
               
               // MARK: isCurrent
               VStack(alignment: .leading) {
                  if !newAccount.isCurrent {
                     Toggle("Long-term", isOn: $newAccount.isCurrent)
                  }
                  else {
                     Toggle("Current", isOn: $newAccount.isCurrent)
                  }
               }
               
               // MARK: Credit or Debit
               VStack(alignment: .leading) {
                  if !newAccount.isDebit {
                     Toggle("Credit Account", isOn: $newAccount.isDebit)
                  }
                  else {
                     Toggle("Debit Account", isOn: $newAccount.isDebit)
                  }
               }
               
               // MARK: Amount
               HStack {
                  Text("Balance: ")
                  if !newAccount.isDebit {
                     Text("$( ")
                     TextField(String(abs(Double(oldAccount.balance) ?? 0.0)), text: $newAccount.balance)
                        .keyboardType(.decimalPad)
                     Spacer()
                     Text(" )")
                  }
                  else {
                     Text("$ ")
                     TextField(oldAccount.balance, text: $newAccount.balance)
                        .keyboardType(.decimalPad)
                  }
               }
               
               //MARK: Notes
               VStack(alignment: .leading, spacing: 0.0) {
                  Text("Notes: ")
                     .padding(.top, 5.0)
                  TextEditor(text: $newAccount.notes)
               }
            }
            
            // MARK: Cancel Button
            Button(action: {
               newAccount.prepareNew(account: inputAccount)
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Save Button
            Button(action: {
               if newAccount.balance.filter({ $0 == "."}).count > 1 {
                  showAlert = true
               }
               
               // Update Account
               newAccount.updateAccount(account: inputAccount, oldAccount: oldAccount)
               
               do {
                  try viewContext.save()
               } catch {
                  let nsError = error as NSError
                  fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
               }
               
               oldAccount.prepare(account: inputAccount)
               newAccount.prepareNew(account: inputAccount)
               self.isPresented.wrappedValue.dismiss()
               
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
         .navigationTitle("Edit Account")
      }
    }
}

//struct AEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        AEditView()
//    }
//}

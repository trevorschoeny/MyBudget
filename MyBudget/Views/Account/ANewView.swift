//
//  ANewView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct ANewView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.date, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
   @State var newAccount = TempAccount()
   @Environment(\.presentationMode) var isPresented
   @State var showAlert = false
   
    var body: some View {
      NavigationView {
         VStack {
            
            Form {
               // MARK: Name
               TextField("Add account name here...", text: $newAccount.name)
               
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
                  if !newAccount.isDebit {
                     Text("$( ")
                     TextField("Starting Amount", text: $newAccount.balance)
                        .keyboardType(.decimalPad)
                     Spacer()
                     Text(" )")
                  }
                  else {
                     Text("$ ")
                     TextField("Starting Amount", text: $newAccount.balance)
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
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Save Button
            Button(action: {
               if newAccount.balance == ""  || newAccount.name == "" {
                  showAlert = true
               }
               // Save Account
               else {
                  newAccount.populateAccount(account: AccountEntity(context: viewContext))
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
         .navigationTitle("Add Account")
      }
    }
}

struct ANewView_Previews: PreviewProvider {
    static var previews: some View {
        ANewView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

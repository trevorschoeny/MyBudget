//
//  SNewView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/8/21.
//

import SwiftUI

struct SNewView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.userOrder, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
   @FetchRequest(
      entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.userOrder, ascending: true)], animation: .default)
   private var budgets: FetchedResults<BudgetEntity>
   
   @State var newSubscription = TempSubscription()
   @Environment(\.presentationMode) var isPresented
   @State var showAlert = false
    var body: some View {
      NavigationView {
         VStack {
            Form {
               // MARK: Name
               TextField("Add subcription name here...", text: $newSubscription.name)
               
               // MARK: Bill Date
               DatePicker("Date of Bill: ", selection: $newSubscription.billDate, displayedComponents: .date)
               
               // MARK: Monthly or Yearly
               if newSubscription.isMonthly {
                  HStack {
                     Text("Monthly")
                     Toggle("", isOn: $newSubscription.isMonthly)
                        .frame(width: 60)
                  }
               }
               else {
                  HStack {
                     Text("Yearly")
                     Toggle("", isOn: $newSubscription.isMonthly)
                        .frame(width: 60)
                  }
               }
               
               // MARK: Amount
               HStack {
                  Text("$ ")
                  TextField("Subscription Price", text: $newSubscription.amount)
                     .keyboardType(.decimalPad)
               }
               
               // MARK: Account
               HStack {
                  Text("Account:")
                  Picker(selection: $newSubscription.account, label: Text("")) {
                     ForEach(accounts) { a in
                        if !a.isRetired {
                           Text(a.name ?? "no name").tag(a as AccountEntity?)
                        }
                     }
                     .lineLimit(1)
                  }
               }
               
               // MARK: Budget
               HStack {
                  Text("Budget:")
                  Picker(selection: $newSubscription.budget, label: Text("")) {
                     ForEach(budgets) { b in
                        if !b.isRetired {
                           Text(b.name ?? "no name").tag(b as BudgetEntity?)
                        }
                     }
                     .lineLimit(1)
                  }
               }
               
               // MARK: Notes
               VStack(alignment: .leading, spacing: 0.0) {
                  Text("Notes: ")
                     .padding(.top, 5.0)
                  TextEditor(text: $newSubscription.notes)
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
               if newSubscription.name == "" ||  newSubscription.amount.filter({ $0 == "."}).count > 1 || newSubscription.account == nil {
                  showAlert = true
               }
               // Save Account
               else {
                  newSubscription.populateSubscription(subscription: SubscriptionEntity(context: viewContext))
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
         .navigationTitle("New Subscription")
      }
    }
}

struct SNewView_Previews: PreviewProvider {
    static var previews: some View {
        SNewView()
    }
}

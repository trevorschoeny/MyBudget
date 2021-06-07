//
//  TFilterView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct TFilterView: View {
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.date, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
   @FetchRequest(
      entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.date, ascending: true)], animation: .default)
   private var budgets: FetchedResults<BudgetEntity>
   
   @Binding var searchInput: SearchParameters
   @Environment(\.presentationMode) var isPresented
   
    var body: some View {
      NavigationView {
         VStack {
            List {
               
               // MARK: Filter by Date
               Toggle("Filter by Date", isOn: $searchInput.dateToggle)
               if searchInput.dateToggle {
                  Toggle("Filter by Date Range", isOn: $searchInput.dateRangeToggle)
                  DatePicker("Date: ", selection: $searchInput.firstDate, displayedComponents: .date)
                  if searchInput.dateRangeToggle {
                     DatePicker("Through: ", selection: $searchInput.secondDate, displayedComponents: .date)
                  }
               }
               
               // MARK: Filter by Credit/Debit
               Picker(selection: $searchInput.debitToggle, label: Text("Type")) {
                  Text("Credit").tag("Credit" as String?)
                  Text("Debit").tag("Debit" as String?)
               }
               .lineLimit(1)
               .pickerStyle(InlinePickerStyle())
               
               // MARK: Filter by Account
               Picker(selection: $searchInput.account, label: Text("Account")) {
                  ForEach(accounts) { a in
                     Text(a.name ?? "no name").tag(a as AccountEntity?)
                  }
               }
               .lineLimit(1)
               .pickerStyle(InlinePickerStyle())
               
               // MARK: Filter by Budget
               if searchInput.debitToggle != "Debit" {
                  Picker(selection: $searchInput.budget, label: Text("Budget")) {
                     ForEach(budgets) { b in
                        Text(b.name ?? "no name").tag(b as BudgetEntity?)
                     }
                  }
                  .lineLimit(1)
                  .pickerStyle(InlinePickerStyle())
               }
            }
            
            // MARK: Clear Filter Button
            Button(action: {
               searchInput.reset()
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Clear Filter")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Ok Button
            Button(action: {
               self.isPresented.wrappedValue.dismiss()
               
            }, label: {
               ZStack {
                  Rectangle()
                     .font(.headline)
                     .foregroundColor(.blue)
                     .frame(height: 55)
                     .cornerRadius(10)
                     .padding(.horizontal)
                  Text("Ok")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            })
            .padding(.bottom)
         }
         .navigationTitle("Filter")
      }
    }
}

//struct TFilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        TFilterView(searchInput: SearchParameters())
//    }
//}

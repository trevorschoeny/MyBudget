//
//  DashboardView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct DashboardView: View {
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.userOrder, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
   @FetchRequest(
      entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.userOrder, ascending: true)], animation: .default)
   private var budgets: FetchedResults<BudgetEntity>
   
   @State var balances = Balances()
   
    var body: some View {
      NavigationView {
         VStack {
            List {
               HStack {
                  Spacer()
               VStack(alignment: .center, spacing: 3) {
                  HStack(spacing: 0) {
                     Text("Total Balance: ")
                     if balances.totalBalance >= 0 {
                        Text("$" + String(balances.totalBalance))
                           .foregroundColor(.green)
                     } else {
                        Text("($" + String(balances.totalBalance) + ")")
                           .foregroundColor(.red)
                     }
                  }
                  .font(.title2)
                  HStack(spacing: 0) {
                     Text("Total Assets: ")
                        .foregroundColor(.gray)
                     Text("$" + String(balances.totalAssets))
                        .foregroundColor(.green)
                  }
                  .font(.footnote)
                  HStack(spacing: 0) {
                     Text("Total Liabilities: ")
                        .foregroundColor(.gray)
                     Text("($" + String(balances.totalLiabilities) + ")")
                        .foregroundColor(.red)
                  }
                  .font(.footnote)
               }
                  Spacer()
               }
               .padding(.vertical, 5)
               HStack {
                  Spacer()
               VStack(alignment: .center, spacing: 3) {
                  HStack(spacing: 0) {
                     Text("Current Balance: ")
                     if balances.currentBalance >= 0 {
                        Text("$" + String(balances.currentBalance))
                           .foregroundColor(.green)
                     } else {
                        Text("($" + String(balances.currentBalance) + ")")
                           .foregroundColor(.red)
                     }
                  }
                  .font(.title2)
                  HStack(spacing: 0) {
                     Text("Current Assets: ")
                        .foregroundColor(.gray)
                     Text("$" + String(balances.currentAssets))
                        .foregroundColor(.green)
                  }
                  .font(.footnote)
                  HStack(spacing: 0) {
                     Text("Current Liabilities: ")
                        .foregroundColor(.gray)
                     Text("($" + String(balances.currentLiabilities) + ")")
                        .foregroundColor(.red)
                  }
                  .font(.footnote)
               }
                  Spacer()
               }
               .padding(.vertical, 5)
               
               // MARK: Accounts
               Section(header: Text("Accounts")) {
                  ForEach (accounts.filter({ a in
                     a.onDashboard
                  }), id: \.self) { a in
                     AListItemView(a: a)
                  }
               }
               
               // MARK: Budgets
               Section(header: Text("Budgets")) {
                  ForEach (budgets.filter({ b in
                     b.onDashboard
                  })) { b in
                     BListItemView(b: b)
                  }
                  .onDelete(perform: { indexSet in
                     
                  })
               }
            }
            .navigationTitle("Dashboard")
//            .navigationBarItems(leading: EditButton(), trailing: addButton)
         }
         .onTapGesture(perform: {
            balances = Balances()
         })
         .onAppear(perform: {
            balances = Balances()
         })
      }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

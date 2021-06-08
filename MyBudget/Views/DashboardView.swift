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
   
   var body: some View {
      NavigationView {
         VStack {
            List {
               HStack {
                  Spacer()
                  VStack(alignment: .center, spacing: 3) {
                     HStack(spacing: 0) {
                        Text("Total Balance: ")
                        if totalBalance >= 0 {
                           Text(formatterFunction(number: totalBalance))
                              .foregroundColor(.green)
                        } else {
                           Text(formatterFunction(number: totalBalance))
                              .foregroundColor(.red)
                        }
                     }
                     .font(.title2)
                     HStack(spacing: 0) {
                        Text("Total Assets: ")
                           .foregroundColor(.gray)
                        Text(formatterFunction(number: totalAssets))
//                           .foregroundColor(.green)
                     }
                     .font(.footnote)
                     HStack(spacing: 0) {
                        Text("Total Liabilities: ")
                           .foregroundColor(.gray)
                        Text(formatterFunction(number: totalLiabilities))
//                           .foregroundColor(.red)
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
                        if currentBalance >= 0 {
                           Text(formatterFunction(number: currentBalance))
                              .foregroundColor(.green)
                        } else {
                           Text(formatterFunction(number: currentBalance))
                              .foregroundColor(.red)
                        }
                     }
                     .font(.title2)
                     HStack(spacing: 0) {
                        Text("Current Assets: ")
                           .foregroundColor(.gray)
                        Text(formatterFunction(number: currentAssets))
//                           .foregroundColor(.green)
                     }
                     .font(.footnote)
                     HStack(spacing: 0) {
                        Text("Current Liabilities: ")
                           .foregroundColor(.gray)
                        Text(formatterFunction(number: currentLiabilities))
//                           .foregroundColor(.red)
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
            .navigationBarItems(trailing: subButton)
         }
      }
   }
   private var subButton: some View {
      return AnyView(
         NavigationLink(destination: SubscriptionView(), label: {
            Image(systemName: "arrow.triangle.2.circlepath.circle")
               .resizable()
               .frame(width: 22, height: 22)
         })
      )
   }
   private var totalBalance: Double {
      var total = 0.0
      for a in accounts {
         total += a.balance
      }
      return total
   }
   private var totalAssets: Double {
      var total = 0.0
      for a in accounts {
         if a.balance > 0 {
            total += a.balance
         }
      }
      return total
   }
   private var totalLiabilities: Double {
      var total = 0.0
      for a in accounts {
         if a.balance < 0 {
            total += a.balance
         }
      }
      return total
   }
   private var currentBalance: Double {
      var total = 0.0
      for a in accounts {
         if a.isCurrent {
            total += a.balance
         }
      }
      return total
   }
   private var currentAssets: Double {
      var total = 0.0
      for a in accounts {
         if a.isCurrent {
            if a.balance > 0 {
               total += a.balance
            }
         }
      }
      return total
   }
   private var currentLiabilities: Double {
      var total = 0.0
      for a in accounts {
         if a.isCurrent {
            if a.balance < 0 {
               total += a.balance
            }
         }
      }
      return total
   }
}

struct DashboardView_Previews: PreviewProvider {
   static var previews: some View {
      DashboardView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
   }
}

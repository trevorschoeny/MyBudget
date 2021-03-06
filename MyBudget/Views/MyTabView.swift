//
//  ContentView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI
import CoreData

struct MyTabView: View {
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.userOrder, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
   var body: some View {
      TabView {
         DashboardView()
            .tabItem {
               VStack {
                  Image(systemName: "dollarsign.circle")
                  Text("Dashboard")
               }
            }
         TransactionView()
            .tabItem {
               VStack {
                  Image(systemName: "list.bullet")
                  Text("Transactions")
               }
            }
         AccountView()
            .tabItem {
               VStack {
                  Image(systemName: "rectangle.3.offgrid.fill")
                  Text("Accounts")
               }
            }
         BudgetView()
            .tabItem {
               VStack {
                  Image(systemName: "chart.pie.fill")
                  Text("Budgets")
               }
            }
      }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      MyTabView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
   }
}

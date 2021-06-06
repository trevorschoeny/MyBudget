//
//  ContentView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI
import CoreData

struct MyTabView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: TransactionEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.name, ascending: true)], animation: .default)
   
   private var transactions: FetchedResults<TransactionEntity>
      
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

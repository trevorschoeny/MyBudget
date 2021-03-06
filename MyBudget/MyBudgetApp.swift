//
//  MyBudgetApp.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

@main
struct MyBudgetApp: App {
   let persistenceController = PersistenceController.shared
   
   var body: some Scene {
      WindowGroup {
         MyTabView()
            .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
      }
   }
}

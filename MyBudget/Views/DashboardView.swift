//
//  DashboardView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct DashboardView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: TransactionEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.name, ascending: true)], animation: .default)
   private var transactions: FetchedResults<TransactionEntity>
   
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.name, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
    var body: some View {
      Button(action: {
         let newAccount = AccountEntity(context: viewContext)
         newAccount.name = "Account x"
         do {
             try viewContext.save()
         } catch {
             let nsError = error as NSError
             fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
      }, label: {
         Text("Add Transaction")
      })
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

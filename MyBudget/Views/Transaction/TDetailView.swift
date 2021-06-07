//
//  TDetailView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct TDetailView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.date, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
   @FetchRequest(
      entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.date, ascending: true)], animation: .default)
   private var budgets: FetchedResults<BudgetEntity>
   
   @State var transaction: TransactionEntity
   @State var showingPopover = false
   @State var oldTransaction = TempT()
   @State var newTransaction = TempT()
   
   var body: some View {
      VStack(alignment: .leading, spacing: 0.0) {
         List {
            
            // MARK: Description
            HStack {
               Text(transaction.name ?? "No Name")
                  .font(.largeTitle)
                  .multilineTextAlignment(.leading)
               Spacer()
            }
            .padding(.vertical, 5.0)
            
            HStack {
               Spacer()
               VStack {
                  // MARK: Amount
                  if transaction.isDebit {
                     Text("$" + String(transaction.amount))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.green)
                  }
                  else {
                     Text("($" + String(transaction.amount) + ")")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red)
                  }
                  
                  // MARK: Account
                  if transaction.isDebit {
                     Text("to " + (transaction.account ?? "No Account"))
                        .font(.title2)
                        .fontWeight(.light)
                  }
                  else {
                     Text("from " + (transaction.account ?? "No Account"))
                        .font(.title2)
                        .fontWeight(.light)
                  }
               }
               .padding(.vertical)
               Spacer()
            }
            
            // MARK: Date
            HStack {
               Text("Date: ")
                  .foregroundColor(Color.gray)
               Spacer()
               Text(transaction.date?.addingTimeInterval(0) ?? Date(), style: .date)
            }
            
            if !transaction.isDebit {
               // MARK: Budget
               HStack {
                  Text("Budget: ")
                     .foregroundColor(Color.gray)
                  Spacer()
                  Text(transaction.budget ?? "")
               }
            }
            
            // MARK: Notes
            VStack(alignment: .leading) {
               Text("Notes:")
                  .foregroundColor(Color.gray)
                  .padding(.vertical, 6.0)
               if transaction.notes != "" && transaction.notes != nil {
                  Text(transaction.notes ?? "")
                     .multilineTextAlignment(.leading)
                     .padding(.bottom, 6.0)
               }
            }
         }
         .listStyle(InsetGroupedListStyle())
      }
      .navigationBarItems(trailing: editButton)
      .navigationTitle("Transaction")
      .popover(isPresented: self.$showingPopover, content: {
         TEdit(oldT: $oldTransaction, newT: $newTransaction, inputTransaction: $transaction)
      })
   }
   private var editButton: some View {
      Button(action: {
         oldTransaction.prepareTempT(transaction: transaction)
         newTransaction.prepareTempTNew(transaction: transaction)
         showingPopover = true
      }, label: {
         Text("Edit")
            .foregroundColor(.blue)
      })
   }
}

struct TDetailView_Previews: PreviewProvider {
   static var previews: some View {
      TDetailView(transaction: TransactionEntity())
         .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
   }
}

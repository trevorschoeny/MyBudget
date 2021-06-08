//
//  TDetailView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct TDetailView: View {
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.date, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
   @FetchRequest(
      entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.date, ascending: true)], animation: .default)
   private var budgets: FetchedResults<BudgetEntity>
   
   @State var transaction: TransactionEntity
   @State var showingPopover = false
   @State var oldTransaction = TempTransaction()
   @State var newTransaction = TempTransaction()
   
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
                     Text(formatterFunction(number: transaction.amount))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.green)
                  }
                  else {
                     Text(formatterFunction(number: transaction.amount))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red)
                  }
                  
                  // MARK: Account
                  if transaction.isDebit {
                     Text("to " + (transaction.account?.name ?? "No Account"))
                        .font(.title2)
                        .fontWeight(.light)
                  }
                  else {
                     Text("from " + (transaction.account?.name ?? "No Account"))
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
            
            // MARK: Budget
            if !transaction.isDebit {
               HStack {
                  Text("Budget: ")
                     .foregroundColor(Color.gray)
                  Spacer()
                  Text(transaction.budget?.name ?? "")
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
         TEditView(oldTransaction: $oldTransaction, newTransaction: $newTransaction, inputTransaction: $transaction)
      })
   }
   private var editButton: some View {
      Button(action: {
         oldTransaction.prepare(transaction: transaction)
         newTransaction.prepareNew(transaction: transaction)
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

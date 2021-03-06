//
//  ADetailView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct ADetailView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: TransactionEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)], animation: .default)
   private var transactions: FetchedResults<TransactionEntity>
   
   @State var showingPopover = false
   
   @State var account: AccountEntity
   @State var oldAccount = TempAccount()
   @State var newAccount = TempAccount()
   
   var body: some View {
      VStack {
         List {
            
            // MARK: Description
            VStack(alignment: .leading) {
               Text(account.name ?? "No Name")
                  .font(.largeTitle)
                  .multilineTextAlignment(.leading)
               if account.isDebit {
                  HStack(spacing: 0) {
                     Text("Debit Account • ")
                        .font(.callout)
                        .foregroundColor(Color.gray)
                     if account.isCurrent {
                        Text("Current")
                           .font(.callout)
                           .foregroundColor(Color.gray)
                     } else {
                        Text("Long-Term")
                           .font(.callout)
                           .foregroundColor(Color.gray)
                     }
                  }
               } else {
                  HStack(spacing: 0) {
                     Text("Credit Account • ")
                        .font(.callout)
                        .foregroundColor(Color.gray)
                     if account.isCurrent {
                        Text("Current")
                           .font(.callout)
                           .foregroundColor(Color.gray)
                     } else {
                        Text("Long-Term")
                           .font(.callout)
                           .foregroundColor(Color.gray)
                     }
                  }
               }
               // MARK: Date
               HStack(spacing: 0) {
                  Text("Created on ")
                     .foregroundColor(.gray)
                  Text(account.date ?? Date(), style: .date)
                     .foregroundColor(.gray)
               }
               .font(.footnote)
            }
            .padding(.vertical, 5.0)
            
            HStack {
               Spacer()
               VStack {
                  // MARK: Amount
                  if account.balance >= 0.0 {
                     Text(formatterFunction(number: account.balance))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.green)
                  }
                  else {
                     Text(formatterFunction(number: account.balance))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red)
                  }
               }
               .padding(.vertical)
               Spacer()
            }
            
            // MARK: Notes
            VStack(alignment: .leading) {
               Text("Notes:")
                  .foregroundColor(Color.gray)
                  .padding(.vertical, 6.0)
               if account.notes != "" && account.notes != nil {
                  Text(account.notes ?? "")
                     .multilineTextAlignment(.leading)
                     .padding(.bottom, 6.0)
               }
            }
            
            // MARK: Transactions
            Section(header: Text("Transactions")) {
               ForEach(transactions.filter({ transaction in
                transaction.account == account || transaction.account2 == account
               })) { t in
                  TListItemView(t: t)
               }
               .onDelete(perform: { indexSet in
                  delete(indexSet: indexSet)
               })
            }
         }
         .listStyle(InsetGroupedListStyle())
      }
      .navigationBarItems(trailing: editButton)
      .navigationTitle("Account")
      .popover(isPresented: self.$showingPopover, content: {
         AEditView(oldAccount: $oldAccount, newAccount: $newAccount, inputAccount: $account)
      })
   }
   private var editButton: some View {
      Button(action: {
         oldAccount.prepare(account: account)
         newAccount.prepareNew(account: account)
         showingPopover = true
      }, label: {
         Text("Edit")
            .foregroundColor(.blue)
      })
   }
   private func delete(indexSet: IndexSet) {
      viewContext.perform {
         
         let transaction = transactions.filter({ t in
            t.account == account
         })[indexSet.first ?? 0]
        
        transaction.account?.balance += transaction.amount
        transaction.account2?.balance -= transaction.amount
        transaction.budget?.balance += transaction.amount
        transaction.budget2?.balance -= transaction.amount
         
         indexSet.map { transactions.filter({ t in
            t.account == account
         })[$0] }.forEach(viewContext.delete)
         do {
             try viewContext.save()
         } catch {
             let nsError = error as NSError
             fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
      }
   }
}

//struct ADetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ADetailView()
//    }
//}

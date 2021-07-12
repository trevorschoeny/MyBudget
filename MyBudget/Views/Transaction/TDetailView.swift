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
                VStack {
                    HStack {
                        Text(transaction.name ?? "No Name")
                            .font(.largeTitle)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.vertical, 5.0)
                    
                    // MARK: Date
                    HStack {
                        Text(transaction.date?.addingTimeInterval(0) ?? Date(), style: .date)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                
                // MARK: Amount
                HStack {
                    Spacer()
                    VStack {
                        if transaction.account != nil && transaction.account2 != nil {
                            Text(formatterFunction(number: transaction.amount))
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                        } else if transaction.account != nil {
                            Text("(" + formatterFunction(number: transaction.amount) + ")")
                                .foregroundColor(Color.red)
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                        } else {
                            Text(formatterFunction(number: transaction.amount))
                                .foregroundColor(Color.green)
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.vertical)
                    Spacer()
                }
                
                // MARK: Accounts
                if transaction.account != nil {
                    HStack(spacing: 0) {
                        Text("Credit from account: ")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(transaction.account?.name ?? "No Account")
                    }
                }
                if transaction.account2 != nil {
                    HStack(spacing: 0) {
                        Text("Debit to account: ")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(transaction.account2?.name ?? "No Account")
                        
                    }
                }
                
                // MARK: Budget
                if transaction.budget != nil {
                    HStack(spacing: 0) {
                        Text("Credit from budget: ")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(transaction.budget?.name ?? "No Account")
                    }
                }
                if transaction.budget2 != nil {
                    HStack(spacing: 0) {
                        Text("Debit to budget: ")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(transaction.budget2?.name ?? "No Account")
                        
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

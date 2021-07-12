//
//  TNewView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct TNewView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.userOrder, ascending: true)], animation: .default)
    private var accounts: FetchedResults<AccountEntity>
    
    @FetchRequest(
        entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.userOrder, ascending: true)], animation: .default)
    private var budgets: FetchedResults<BudgetEntity>
    
    @State var newTransaction = TempTransaction()
    @Environment(\.presentationMode) var isPresented
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // MARK: Description
                    TextField("Add description here...", text: $newTransaction.name)
                    
                    // MARK: Date
                    DatePicker("Date of Transaction: ", selection: $newTransaction.date, displayedComponents: .date)
                    
                    // MARK: Amount
                    HStack {
                        Text("$ ")
                        TextField("Amount: ", text: $newTransaction.amount)
                            .keyboardType(.decimalPad)
                    }
                    
                    // MARK: Credit from Account
                    HStack(spacing: 0) {
                        Text("Credit from account:")
                        Picker(selection: $newTransaction.account, label: Text("")) {
                            if accounts.count > 0 {
                                ForEach(accounts) { a in
                                    if !a.isRetired {
                                        Text(a.name ?? "no name").tag(a as AccountEntity?)
                                    }
                                }
                            }
                        }
                        .lineLimit(1)
                    }
                    
                    // MARK: Debit to Account
                    HStack(spacing: 0) {
                        Text("Debit to account:")
                        Picker(selection: $newTransaction.account2, label: Text("")) {
                            if accounts.count > 0 {
                                ForEach(accounts) { a in
                                    if !a.isRetired {
                                        Text(a.name ?? "no name").tag(a as AccountEntity?)
                                    }
                                }
                            }
                        }
                        .lineLimit(1)
                    }
                    
                    // MARK: Credit from Budget
                    HStack(spacing: 0) {
                        Text("Credit from budget:")
                        Picker(selection: $newTransaction.budget, label: Text("")) {
                            if budgets.count > 0 {
                                ForEach(budgets) { b in
                                    if !b.isRetired {
                                        Text(b.name ?? "no name").tag(b as BudgetEntity?)
                                    }
                                }
                            }
                        }
                        .lineLimit(1)
                    }
                    
                    // MARK: Debit to Budget
                    HStack(spacing: 0) {
                        Text("Debit to budget:")
                        Picker(selection: $newTransaction.budget2, label: Text("")) {
                            if budgets.count > 0 {
                                ForEach(budgets) { b in
                                    if !b.isRetired {
                                        Text(b.name ?? "no name").tag(b as BudgetEntity?)
                                    }
                                }
                            }
                        }
                        .lineLimit(1)
                    }
                    if newTransaction.account != nil || newTransaction.account2 != nil || newTransaction.budget != nil || newTransaction.budget2 != nil {
                        Button("Clear") {
                            newTransaction.account = nil
                            newTransaction.account2 = nil
                            newTransaction.budget = nil
                            newTransaction.budget2 = nil
                        }
                    }
                    
                    //MARK: Notes
                    VStack(alignment: .leading, spacing: 0.0) {
                        Text("Notes: ")
                            .padding(.top, 5.0)
                        
                        TextEditor(text: $newTransaction.notes)
                    }
                }
                
                // MARK: Clear Button
                Button(action: {
                    self.isPresented.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel ")
                        .foregroundColor(.blue)
                })
                .padding(.top, 5.0)
                
                
                // MARK: Save Button
                Button(action: {
                    newTransaction.populateTransaction(transaction: TransactionEntity(context: viewContext))
                    
                    newTransaction.account?.balance -= Double(newTransaction.amount) ?? 0.0
                    newTransaction.account2?.balance += Double(newTransaction.amount) ?? 0.0
                    newTransaction.budget?.balance -= Double(newTransaction.amount) ?? 0.0
                    newTransaction.budget2?.balance += Double(newTransaction.amount) ?? 0.0
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    
                    self.isPresented.wrappedValue.dismiss()
                    
                }, label: {
                    ZStack {
                        Rectangle()
                            .font(.headline)
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                            .frame(height: 55)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                })
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                .cornerRadius(10)
                .padding([.leading, .bottom, .trailing])
            }
            .navigationTitle("Add Transaction")
        }
    }
}

struct TNew_Previews: PreviewProvider {
    static var previews: some View {
        TNewView()
    }
}

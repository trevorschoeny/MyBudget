//
//  BDetailView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct BDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: TransactionEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)], animation: .default)
    private var transactions: FetchedResults<TransactionEntity>
    
    @State var budget: BudgetEntity
    @State var oldBudget = TempBudget()
    @State var newBudget = TempBudget()
    
    @State var showingPopover = false
    @State var showingFundPopover = false
    @State var showAlert = false
    @State private var selectedItem: String?
    
    var body: some View {
        VStack {
            List {
                
                // MARK: Description
                VStack(alignment: .leading) {
                    Text(budget.name ?? "No Name")
                        .font(.largeTitle)
                        .multilineTextAlignment(.leading)
                    // MARK: Date
                    HStack(spacing: 0) {
                        Text("Created on ")
                            .foregroundColor(.gray)
                        Text(budget.date ?? Date(), style: .date)
                            .foregroundColor(.gray)
                    }
                    .font(.footnote)
                }
                .padding(.vertical, 5.0)
                
                // MARK: Balance & Budget Amount
                BBalanceView(budget: budget)
                
                // MARK: Past Periods
                NavigationLink("Past Periods", destination: BPeriodView(budget: budget), tag: budget.wName, selection: $selectedItem)
                
                // MARK: Notes
                VStack(alignment: .leading) {
                    Text("Notes:")
                        .foregroundColor(Color.gray)
                        .padding(.vertical, 6.0)
                    if budget.notes != "" && budget.notes != nil {
                        Text(budget.notes ?? "")
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 6.0)
                    }
                }
                
                // MARK: Transactions
                Section(header: Text("Transactions")) {
                    ForEach(transactions.filter({ transaction in
                        transaction.budget == budget || transaction.budget2 == budget
                    })) { t in
                        TListItemView(t: t)
                    }
                    .onDelete(perform: { indexSet in
                        delete(indexSet: indexSet)
                    })
                }
            }
            .refreshOnAppear(selection: $selectedItem)
            .popover(isPresented: self.$showingFundPopover, content: {
                BNewPeriodView(inputBudget: budget)
            })
            .listStyle(InsetGroupedListStyle())
            
            // MARK: New Period
            VStack {
                Button(action: {
                    showAlert = true
                }, label: {
                    ZStack {
                        Rectangle()
                            .font(.headline)
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                            .frame(height: 55)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        Text("New Period")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                })
                .padding(.bottom, 10)
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Would you like to start a new period for " + budget.name! + "?"),
                          primaryButton: .default(Text("Yes")) {
                            showingFundPopover = true
                          },
                          secondaryButton: .cancel())
                })
                .popover(isPresented: self.$showingPopover, content: {
                    BEditView(oldBudget: $oldBudget, newBudget: $newBudget, inputBudget: $budget)
                })
            }
        }
        .navigationBarItems(trailing: editButton)
        .navigationTitle("Budget")
    }
    private var editButton: some View {
        Button(action: {
            oldBudget.prepare(budget: budget)
            newBudget.prepareNew(budget: budget)
            showingPopover = true
        }, label: {
            Text("Edit")
                .foregroundColor(.blue)
        })
    }
    private func delete(indexSet: IndexSet) {
        viewContext.perform {
            
            let transaction = transactions.filter({ t in
                t.budget == budget
            })[indexSet.first ?? 0]
            
            transaction.account?.balance += transaction.amount
            transaction.account2?.balance -= transaction.amount
            transaction.budget?.balance += transaction.amount
            transaction.budget2?.balance -= transaction.amount
            
            indexSet.map { transactions.filter({ t in
                t.budget == budget
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

//struct BudgetDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BDetailView()
//    }
//}

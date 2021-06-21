//
//  BRecoveryView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/20/21.
//

import SwiftUI

struct BRecoveryView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.userOrder, ascending: true), NSSortDescriptor(keyPath: \BudgetEntity.date, ascending: true)], animation: .default)
   private var budgets: FetchedResults<BudgetEntity>
   
   @State var recoverBudget: BudgetEntity?
   @State var showAlert = false
   @State var deleteIndexSet: IndexSet?
   @State var hasRetired = false
   
   var body: some View {
      VStack {
         
         if !hasRetired {
            Text("No Retired Budgets")
         } else {
            Spacer()
            // MARK: Budget List
            Picker(selection: $recoverBudget, label: Text("")) {
               if budgets.count > 0 {
                  ForEach(budgets) { b in
                     if b.isRetired {
                        Text(b.name ?? "no name").tag(b as BudgetEntity?)
                     }
                  }
               }
            }
            Spacer()
            
            // MARK: Delete Budget
            Button {
               showAlert = true
            } label: {
               Text("Delete Forever")
                  .foregroundColor(.red)
            }
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Are you sure?"),
                     message: Text("Once deleted, this budget is not recoverable."),
                     primaryButton: .destructive(Text("Delete")) {
                        delete()
                     },
                     secondaryButton: .cancel())
            })
            
            // MARK: Recover Budget
            Button {
               let str = recoverBudget?.name?.dropLast(10)
               recoverBudget?.name = String(str ?? "")
               recoverBudget?.isRetired = false
               do {
                  try viewContext.save()
               } catch {
                  let nsError = error as NSError
                  fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
               }
               checkRetired()
            } label: {
               ZStack {
                  Rectangle()
                     .font(.headline)
                     .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                     .frame(height: 55)
                     .cornerRadius(10)
                     .padding(.horizontal)
                  Text("Recover")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            }
            .padding(.bottom, 10)
         }
      }
      .navigationTitle("Retired Budgets")
      .onAppear {
         checkRetired()
      }
   }
   private func delete() {
      viewContext.perform {
         viewContext.delete(recoverBudget ?? AccountEntity())
         do {
            try viewContext.save()
         } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
         checkRetired()
      }
   }
   private func checkRetired() {
      hasRetired = false
      for b in budgets {
         if b.isRetired {
            if hasRetired == false {
               recoverBudget = b
            }
            hasRetired = true
         }
      }
   }
}

struct BRecoveryView_Previews: PreviewProvider {
   static var previews: some View {
      BRecoveryView()
   }
}

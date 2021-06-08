//
//  BPeriodView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct BPeriodView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @ObservedObject var budget: BudgetEntity
   
   @State var showAlert = false
   @State var deleteIndexSet: IndexSet?
   
   var body: some View {
      VStack {
         List {
            Section {
               ForEach(budget.periodArray) { p in
                  VStack(alignment: .leading) {
                     Text(p.wDate, style: .date)
                     HStack(spacing: 0) {
                        if  p.endBalance < 0 {
                           Text(formatterFunction(number: p.endBalance))
                              .foregroundColor(.red)
                              .fontWeight(.semibold)
                        }
                        else if  p.endBalance == 0 {
                           Text(formatterFunction(number:  p.endBalance))
                              .foregroundColor(.red)
                              .fontWeight(.semibold)
                        }
                        else if  p.endBalance <= (p.budgetAmount * 0.25) {
                           Text(formatterFunction(number:  p.endBalance))
                              .foregroundColor(.orange)
                              .fontWeight(.semibold)
                        }
                        else if  p.endBalance <= (p.budgetAmount * 0.5) {
                           Text(formatterFunction(number:  p.endBalance))
                              .foregroundColor(.yellow)
                              .fontWeight(.semibold)
                        }
                        else {
                           Text(formatterFunction(number:  p.endBalance))
                              .foregroundColor(.green)
                              .fontWeight(.semibold)
                        }
                        Text(" left of ")
                        Text(formatterFunction(number: p.budgetAmount))
                           .fontWeight(.semibold)
                        Text(" with ")
                        Text(formatterFunction(number: p.extraAmount))
                           .fontWeight(.semibold)
                        Text(" extra funds.")
                     }
                     .font(.footnote)
                     .foregroundColor(.gray)
                  }
               }
               .onDelete(perform: { indexSet in
                  showAlert = true
                  deleteIndexSet = indexSet
               })
               .alert(isPresented: $showAlert, content: {
                  Alert(title: Text("Are you sure?"),
                        message: Text("Once deleted, this period is not recoverable."),
                        primaryButton: .destructive(Text("Delete")) {
                           delete(indexSet: deleteIndexSet!)
                        },
                        secondaryButton: .cancel())
               })
            }
         }
         .navigationTitle("Past Periods")
      }
   }
   private func delete(indexSet: IndexSet) {
      viewContext.perform {
         budget.removeFromPeriod(budget.periodArray[indexSet.first ?? 0])
         do {
            try viewContext.save()
         } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
      }
   }
}

//struct BPeriodView_Previews: PreviewProvider {
//   static var previews: some View {
//      BPeriodView(budget: BudgetEntity())
//   }
//}

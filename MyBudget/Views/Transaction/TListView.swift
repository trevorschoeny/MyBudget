//
//  TListView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct TListView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: TransactionEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)], animation: .default)
   private var transactions: FetchedResults<TransactionEntity>
   
   @Binding var searchInput: SearchParameters
   
   var body: some View {
      List {
         ForEach(transactions.filter({ t in
            checkFilter(t: t)
         })) { t in
            TListItemView(t: t)
         }
         .onDelete(perform: { indexSet in
            delete(indexSet: indexSet)
         })
      }
   }
   private func delete(indexSet: IndexSet) {
      viewContext.perform {
         indexSet.map { transactions[$0] }.forEach(viewContext.delete)
         do {
             try viewContext.save()
         } catch {
             let nsError = error as NSError
             fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
      }
   }
   func checkFilter(t: TransactionEntity) -> Bool {
      
      // Account
      if searchInput.account != nil && t.account?.name != searchInput.account?.name {
         return false
      }
      // Budget
      if searchInput.debitToggle != "Debit" {
         if searchInput.budget != nil && t.budget?.name != searchInput.budget?.name {
            return false
         }
      }
      // Debit
      if searchInput.debitToggle == "Credit" && t.isDebit {
         return false
      }
      // Credit
      if searchInput.debitToggle == "Debit" && !t.isDebit {
         return false
      }
      // Date & Date Range
      if searchInput.dateToggle {
         if !searchInput.dateRangeToggle {
            if !Calendar.current.isDate(searchInput.firstDate.startOfDay, inSameDayAs:t.date?.startOfDay ?? Date()) {
               return false
            }
         } else {
            if !(t.date ?? Date() >= searchInput.firstDate.startOfDay && t.date ?? Date() <= searchInput.secondDate.startOfDay) {
               return false
            }
         }
      }
      
      // Text & Notes
      let nameMatch = t.name?.lowercased().contains(searchInput.text?.lowercased() ?? "") ?? false
      let notesMatch = t.notes?.lowercased().contains(searchInput.text?.lowercased() ?? "") ?? false
      if (searchInput.text == nil || searchInput.text == "") {
         return true
      } else if nameMatch {
         return true
      } else if notesMatch {
         return true
      }
      return false
   }
}

//struct TListView_Previews: PreviewProvider {
//   static var previews: some View {
//      TListView(searchInput: SearchParameters()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//   }
//}

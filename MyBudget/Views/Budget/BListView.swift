//
//  BListView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct BListView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.userOrder, ascending: true), NSSortDescriptor(keyPath: \BudgetEntity.date, ascending: true)], animation: .default)
   private var budgets: FetchedResults<BudgetEntity>
   
   @Binding var editMode: EditMode
   
    var body: some View {
      List {
         ForEach(budgets) { b in
            BListItemView(b: b)
         }
         .onDelete(perform: { indexSet in
            delete(indexSet: indexSet)
         })
         .onMove(perform: { indices, newOffset in
            move(source: indices, destination: newOffset)
         })
      }
    }
   private func move(source: IndexSet, destination: Int) {
      viewContext.perform {
         
         // Make an array of items from fetched results
         var revisedBudgets: [ BudgetEntity ] = budgets.map{ $0 }

         // change the order of the items in the array
         revisedBudgets.move(fromOffsets: source, toOffset: destination )

         // update the userOrder attribute in revisedItems to
         // persist the new order. This is done in reverse order
         // to minimize changes to the indices.
         for reverseIndex in stride( from: revisedBudgets.count - 1,
                                     through: 0,
                                     by: -1 )
         {
             revisedBudgets[ reverseIndex ].userOrder =
                 Int16( reverseIndex )
         }
         do {
            try viewContext.save()
         } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
      }
   }
   private func delete(indexSet: IndexSet) {
      viewContext.perform {
         indexSet.map { budgets[$0] }.forEach(viewContext.delete)
         do {
            try viewContext.save()
         } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
      }
   }
}

//struct BListView_Previews: PreviewProvider {
//   @State private var editMode = EditMode.inactive
//    static var previews: some View {
//        BListView(editMode: $editMode)
//    }
//}

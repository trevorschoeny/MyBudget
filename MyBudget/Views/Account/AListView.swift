//
//  AListView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct AListView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.userOrder, ascending: true), NSSortDescriptor(keyPath: \AccountEntity.date, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
   @Binding var editMode: EditMode
   @State var showAlert = false
   @State var deleteIndexSet: IndexSet?
   
   var body: some View {
      List {
         ForEach(accounts) { a in
            AListItemView(a: a)
         }
         .onDelete(perform: { indexSet in
            showAlert = true
            deleteIndexSet = indexSet
         })
         .onMove(perform: { indices, newOffset in
            move(source: indices, destination: newOffset)
         })
         .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Are you sure?"),
                  message: Text("Once deleted, this account is not recoverable."),
                  primaryButton: .destructive(Text("Delete")) {
                     delete(indexSet: deleteIndexSet!)
                  },
                  secondaryButton: .cancel())
         })
      }
   }
   private func move(source: IndexSet, destination: Int) {
      viewContext.perform {
         
         // Make an array of items from fetched results
         var revisedAccounts: [ AccountEntity ] = accounts.map{ $0 }

         // change the order of the items in the array
         revisedAccounts.move(fromOffsets: source, toOffset: destination )

         // update the userOrder attribute in revisedItems to
         // persist the new order. This is done in reverse order
         // to minimize changes to the indices.
         for reverseIndex in stride( from: revisedAccounts.count - 1,
                                     through: 0,
                                     by: -1 )
         {
             revisedAccounts[ reverseIndex ].userOrder =
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
         indexSet.map { accounts[$0] }.forEach(viewContext.delete)
         do {
            try viewContext.save()
         } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
      }
   }
}

//struct AListView_Previews: PreviewProvider {
//   static var previews: some View {
//      AListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//   }
//}

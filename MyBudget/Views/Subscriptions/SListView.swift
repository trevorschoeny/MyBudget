//
//  SListView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/8/21.
//

import SwiftUI

struct SListView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: SubscriptionEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SubscriptionEntity.billDate, ascending: true)], animation: .default)
   private var subscriptions: FetchedResults<SubscriptionEntity>
   
   @State var showAlert = false
   @State var deleteIndexSet: IndexSet?
   
   var body: some View {
      List {
         ForEach(subscriptions) { s in
            SListItemView(s: s)
         }
         .onDelete(perform: { indexSet in
            showAlert = true
            deleteIndexSet = indexSet
         })
         .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Are you sure?"),
                  message: Text("Once deleted, this subscription is not recoverable."),
                  primaryButton: .destructive(Text("Delete")) {
                     delete(indexSet: deleteIndexSet!)
                  },
                  secondaryButton: .cancel())
         })
      }
      .listStyle(InsetGroupedListStyle())
   }
   private func delete(indexSet: IndexSet) {
      viewContext.perform {
         indexSet.map { subscriptions[$0] }.forEach(viewContext.delete)
         do {
            try viewContext.save()
         } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
      }
   }
}

struct SListView_Previews: PreviewProvider {
   static var previews: some View {
      SListView()
   }
}

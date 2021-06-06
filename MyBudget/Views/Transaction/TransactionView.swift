//
//  TransactionView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct TransactionView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: TransactionEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.name, ascending: true)], animation: .default)
   private var transactions: FetchedResults<TransactionEntity>
   
   @State var searchInput = SearchParameters()
   @State var showingNewTPopover = false
   @State var showingFilterPopover = false
   
   var body: some View {
      NavigationView {
         VStack {
            TListView(searchInput: $searchInput)
            HStack {
               SearchBarView(text: $searchInput.text.bound)
                  .padding(.bottom, 10.0)
               Button(action: { showingFilterPopover = true }, label: {
                  Text("Filter")
               })
               .padding(.trailing)
               .offset(y:-5)
               .popover(isPresented: $showingFilterPopover, content: {
                  TFilterView(searchInput: $searchInput)
               })
            }
         }
         .navigationTitle("Transactions")
         .navigationBarItems(trailing: addButton)
      }
      .popover(isPresented: $showingNewTPopover, content: {
         TNew()
      })
   }
   private var addButton: some View {
      return AnyView(
         Button(action: {
            showingNewTPopover = true
         }, label: {
            Image(systemName: "plus.circle")
               .resizable()
               .frame(width: 22, height: 22)
         })
      )
   }
}

struct TransactionView_Previews: PreviewProvider {
   static var previews: some View {
      TransactionView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
   }
}

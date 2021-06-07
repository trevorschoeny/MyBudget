//
//  TransactionView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct TransactionView: View {
   
   @State var searchInput = SearchParameters()
   @State var showingNewTPopover = false
   @State var showingFilterPopover = false
   
   var body: some View {
      NavigationView {
         VStack {
            TListView(searchInput: $searchInput)
            HStack {
               SearchBarView(text: $searchInput.text.bound)
                  .padding(.leading, 10)
               Button(action: { showingFilterPopover = true }, label: {
                  if !searchInput.isFiltering() {
                     Image(systemName: "line.horizontal.3.decrease.circle")
                        .resizable()
                        .frame(width: 22, height: 22)
                  } else {
                     Image(systemName: "line.horizontal.3.decrease.circle.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                  }
               })
               .padding(.trailing, 25)
               .popover(isPresented: $showingFilterPopover, content: {
                  TFilterView(searchInput: $searchInput)
               })
            }
            .padding(.bottom, 10)
            .padding(.vertical, 5)
         }
         .navigationTitle("Transactions")
         .navigationBarItems(trailing: addButton)
      }
      .popover(isPresented: $showingNewTPopover, content: {
         TNewView()
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

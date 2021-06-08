//
//  BudgetView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct BudgetView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @State private var editMode = EditMode.inactive
   @State var showingPopover = false
   
    var body: some View {
      NavigationView {
         VStack {
            BListView(editMode: $editMode)
         }
         .navigationTitle("Budgets")
         .navigationBarItems(leading: EditButton(), trailing: addButton)
         .environment(\.editMode, $editMode)
      }
      .popover(isPresented: $showingPopover, content: {
         BNewView()
      })
    }
   private var addButton: some View {
      return AnyView(
         Button(action: {
            showingPopover = true
         }, label: {
            Image(systemName: "plus.circle")
               .resizable()
               .frame(width: 22, height: 22)
         })
      )
   }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

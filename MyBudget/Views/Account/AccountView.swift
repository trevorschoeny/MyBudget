//
//  AccountView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI

struct AccountView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.userOrder, ascending: true), NSSortDescriptor(keyPath: \AccountEntity.date, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
   @State var editMode = EditMode.inactive
   @State var showingRecoveryPopover = false
   @State var showingPopover = false
   
   var body: some View {
      NavigationView {
         VStack {
            AListView(editMode: $editMode)
         }
         .navigationTitle("Accounts")
         .navigationBarItems(leading: EditButton(), trailing: addButton)
         .environment(\.editMode, $editMode)
      }
      .popover(isPresented: $showingPopover, content: {
         ANewView()
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

struct AccountView_Previews: PreviewProvider {
   static var previews: some View {
      AccountView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
   }
}

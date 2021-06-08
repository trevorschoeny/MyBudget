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
   @State var showingPeriodPopover = false
   @State var showAlertPeriod = false
   
   var body: some View {
      NavigationView {
         VStack {
            BListView(editMode: $editMode)
            
            // MARK: New Period
            VStack {
               Button(action: {
                  showAlertPeriod = true
               }, label: {
                  ZStack {
                     Rectangle()
                        .font(.headline)
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                        .frame(height: 55)
                        .cornerRadius(10)
                        .padding(.horizontal)
                     Text("New Period")
                        .font(.headline)
                        .foregroundColor(.white)
                  }
               })
               .padding(.bottom, 10)
               .alert(isPresented: $showAlertPeriod, content: {
                  Alert(title: Text("End this period and start a new one?"),
                        primaryButton: .default(Text("Yes")) {
                           showingPeriodPopover = true
                        },
                        secondaryButton: .cancel())
               })
            }
            .navigationTitle("Budgets")
            .navigationBarItems(leading: EditButton(), trailing: addButton)
         }
         .popover(isPresented: $showingPopover, content: {
            BNewView()
         })
         .environment(\.editMode, $editMode)
      }
      .popover(isPresented: $showingPeriodPopover, content: {
         BNewPeriodView()
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

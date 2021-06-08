//
//  SubscriptionView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/8/21.
//

import SwiftUI

struct SubscriptionView: View {
   @State var showingPopover = false
   
   var body: some View {
      VStack {
         SListView()
      }
      .navigationTitle("Subscriptions")
      .navigationBarItems(trailing: addButton)
      .popover(isPresented: $showingPopover, content: {
         SNewView()
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
               .offset(x: -8)
         })
      )
   }
}

struct SubscriptionView_Previews: PreviewProvider {
   static var previews: some View {
      SubscriptionView()
   }
}

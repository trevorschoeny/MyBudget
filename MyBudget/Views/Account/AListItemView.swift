//
//  AListItemView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import SwiftUI

struct AListItemView: View {
   @Environment(\.managedObjectContext) private var viewContext
   @ObservedObject var a: AccountEntity
   
    var body: some View {
      NavigationLink(
         destination: DashboardView(),
         label: {
            HStack {
               VStack(alignment: .leading) {
                  Text(a.name ?? "No Name")
                  HStack {
                     if a.isDebit {
                        Text("Debit Account")
                     } else {
                        Text("Credit Account")
                     }
                  }
                  .foregroundColor(.gray)
                  .font(/*@START_MENU_TOKEN@*/.footnote/*@END_MENU_TOKEN@*/)
               }
               Spacer()
               if a.balance >= 0 {
                  Text("$" + String(a.balance) )
                     .foregroundColor(.green)
                     .padding(.trailing)
               }
               else {
                  Text("($" + String(abs(a.balance)) + ")")
                     .foregroundColor(.red)
                     .padding(.trailing)
               }
            }
         })
    }
}

//struct AListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AListItemView()
//    }
//}

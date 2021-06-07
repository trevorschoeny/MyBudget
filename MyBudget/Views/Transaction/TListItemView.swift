//
//  TListItemView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import SwiftUI
import CoreData

struct TListItemView: View {
   @Environment(\.managedObjectContext) private var viewContext
   @ObservedObject var t: TransactionEntity
   
    var body: some View {
      NavigationLink(
         destination: TDetailView(transaction: t),
         label: {
            HStack {
               VStack(alignment: .leading) {
                  Text(t.name ?? "No Name")
                     .lineLimit(1)
                  Text(t.date?.addingTimeInterval(0) ?? Date(), style: .date)
                     .font(.footnote)
                     .foregroundColor(Color.gray)
               }
               Spacer()
               VStack(alignment: .trailing) {
                  if !t.isDebit {
                     Text("($\(String(t.amount)))")
                        .foregroundColor(Color.red)
                  } else {
                     Text(String(t.amount))
                        .foregroundColor(Color.green)
                  }
                  Text(t.account ?? "No Account")
                     .font(.footnote)
                     .lineLimit(1)
               }
               .foregroundColor(Color.gray)
            }
         })
    }
}

//struct TListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//      TListItemView(t: TransactionEntity())
//         .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}

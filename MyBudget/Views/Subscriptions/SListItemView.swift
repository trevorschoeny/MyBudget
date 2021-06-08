//
//  SListItemView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/8/21.
//

import SwiftUI

struct SListItemView: View {
   @ObservedObject var s: SubscriptionEntity
   
   var body: some View {
      NavigationLink(destination: SDetailView(subscription: s)) {
         HStack {
            VStack(alignment: .leading) {
               Text(s.wName)
               HStack(spacing: 0) {
                  Text("\(daysUntil(inputDate: s.wBillDate).day!) days left • ")
                  Text(s.account?.name ?? "No Account")
               }
               .font(.footnote)
               .foregroundColor(.gray)
            }
            Spacer()
            Text(formatterFunction(number: s.amount))
               .padding(.trailing)
            
         }
      }
   }
}

struct SListItemView_Previews: PreviewProvider {
   static var previews: some View {
      SListItemView(s: SubscriptionEntity())
   }
}

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
   @State private var selectedItem: String?
   
   var body: some View {
      List {
         if totalMonthly != 0.0 {
            HStack(spacing: 0) {
               Text("Monthly Subscriptions Total: ")
                  .foregroundColor(.gray)
               Text(formatterFunction(number: totalMonthly))
            }
         }
         if totalYearly != 0.0 {
            HStack(spacing: 0) {
               Text("Yearly Subscriptions Total: ")
                  .foregroundColor(.gray)
               Text(formatterFunction(number: totalYearly))
            }
         }
         if totalMonthly != 0.0 || totalYearly != 0.0 {
            HStack(spacing: 0) {
               Text("Annual Total: ")
                  .foregroundColor(.gray)
               Text(formatterFunction(number: totalAnnual))
            }
         }
         Section {
            ForEach(subscriptions) { s in
               SListItemView(s: s, selectedItem: $selectedItem)
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
      }
      .refreshOnAppear(selection: $selectedItem)
      .listStyle(InsetGroupedListStyle())
   }
   private var totalMonthly: Double {
      var total = 0.0
      for s in subscriptions {
         if s.isMonthly {
            total += s.amount
         }
      }
      return total
   }
   private var totalYearly: Double {
      var total = 0.0
      for s in subscriptions {
         if !s.isMonthly {
            total += s.amount
         }
      }
      return total
   }
   private var totalAnnual: Double {
      var total = 0.0
      total += (totalMonthly * 12)
      total += totalYearly
      return total
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

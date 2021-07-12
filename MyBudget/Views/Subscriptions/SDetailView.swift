//
//  SDetailView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/8/21.
//

import SwiftUI

struct SDetailView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @State var showingPopover = false
   
   @State var subscription: SubscriptionEntity
   @State var oldSubscription = TempSubscription()
   @State var newSubscription = TempSubscription()
   
   @State var showAlert = false
   
   var body: some View {
      VStack {
         List {
            
            // MARK: Description
            VStack(alignment: .leading) {
               Text(subscription.wName)
                  .font(.largeTitle)
                  .multilineTextAlignment(.leading)
               if subscription.isMonthly {
                  HStack(spacing: 0) {
                     Text("Monthly")
                        .font(.callout)
                        .foregroundColor(Color.gray)
                  }
               } else {
                  HStack(spacing: 0) {
                     Text("Yearly")
                        .font(.callout)
                        .foregroundColor(Color.gray)
                  }
               }
            }
            .padding(.vertical, 5.0)
            
            // MARK: Amount
            HStack {
               Spacer()
               VStack {
                  Text(formatterFunction(number: subscription.amount))
                     .font(.largeTitle)
                     .fontWeight(.semibold)
               }
               .padding(.vertical)
               Spacer()
            }
            
            // MARK: Date
            HStack(spacing: 0) {
               VStack(alignment: .leading) {
                  Text("Next billing in " + String(daysUntil(inputDate: subscription.wBillDate).day!) + " days")
                  Text(" on \(subscription.wBillDate, style: .date)")
                     .foregroundColor(.gray)
                     .font(.footnote)
               }
            }
            
            // MARK: Account
            HStack {
               Text("Account: ")
                  .foregroundColor(Color.gray)
               Spacer()
               Text(subscription.account?.name ?? "")
            }
            
            // MARK: Budget
            if subscription.budget != nil {
               HStack {
                  Text("Budget: ")
                     .foregroundColor(Color.gray)
                  Spacer()
                  Text(subscription.budget?.name ?? "")
               }
            }
            
            // MARK: Notes
            VStack(alignment: .leading) {
               Text("Notes:")
                  .foregroundColor(Color.gray)
                  .padding(.vertical, 6.0)
               if subscription.notes != "" && subscription.notes != nil {
                  Text(subscription.wNotes)
                     .multilineTextAlignment(.leading)
                     .padding(.bottom, 6.0)
               }
            }
         }
         .listStyle(InsetGroupedListStyle())
         
         // MARK: Bill
         VStack {
            Button(action: {
               showAlert = true
            }, label: {
               ZStack {
                  Rectangle()
                     .font(.headline)
                     .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                     .frame(height: 55)
                     .cornerRadius(10)
                     .padding(.horizontal)
                  Text("Bill")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            })
            .padding(.bottom, 10)
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Bill this subscription as a new transaction?"),
                     primaryButton: .default(Text("Yes")) {
                        var dateComponent = DateComponents()
                        if subscription.isMonthly {
                           dateComponent.month = 1
                           subscription.billDate = Calendar.current.date(byAdding: dateComponent, to: subscription.billDate ?? Date())
                        } else {
                           dateComponent.year = 1
                           subscription.billDate = Calendar.current.date(byAdding: dateComponent, to: subscription.billDate ?? Date())
                        }
                        addTransaction()
                        do {
                           try viewContext.save()
                        } catch {
                           let nsError = error as NSError
                           fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                     },
                     secondaryButton: .cancel())
            })
         }
      }
      .navigationBarItems(trailing: editButton)
      .navigationTitle("Subscription")
      .popover(isPresented: self.$showingPopover, content: {
         SEditView(oldSubscription: $oldSubscription, newSubscription: $newSubscription, inputSubscription: $subscription)
      })
   }
   private var editButton: some View {
      Button(action: {
         oldSubscription.prepare(subscription: subscription)
         newSubscription.prepareNew(subscription: subscription)
         showingPopover = true
      }, label: {
         Text("Edit")
            .foregroundColor(.blue)
      })
   }
   private func addTransaction() {
      let newTransaction = TransactionEntity(context: viewContext)
      newTransaction.amount = subscription.amount * -1
      newTransaction.date = Date()
      newTransaction.name = (subscription.name ?? "") + " Subscription Bill"
//      newTransaction.notes = "Next billing date: "
      newTransaction.account = subscription.account
      newTransaction.budget = subscription.budget
      
      newTransaction.account?.balance += newTransaction.amount
      newTransaction.account?.balance += newTransaction.amount
      
      
   }
}

//struct SDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SDetailView()
//    }
//}

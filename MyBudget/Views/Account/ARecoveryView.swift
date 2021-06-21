//
//  ARecoveryView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/20/21.
//

import SwiftUI

struct ARecoveryView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: AccountEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AccountEntity.userOrder, ascending: true), NSSortDescriptor(keyPath: \AccountEntity.date, ascending: true)], animation: .default)
   private var accounts: FetchedResults<AccountEntity>
   
   @State var recoverAccount: AccountEntity?
   @State var showAlert = false
   @State var deleteIndexSet: IndexSet?
   @State var hasRetired = false
   
   var body: some View {
      VStack {
         
         if !hasRetired {
            Text("No Retired Accounts")
         } else {
            Spacer()
            // MARK: Account List
            Picker(selection: $recoverAccount, label: Text("")) {
               if accounts.count > 0 {
                  ForEach(accounts) { a in
                     if a.isRetired {
                        Text(a.name ?? "no name").tag(a as AccountEntity?)
                     }
                  }
               }
            }
            Spacer()
            
            // MARK: Delete Account
            Button {
               showAlert = true
            } label: {
               Text("Delete Forever")
                  .foregroundColor(.red)
            }
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Are you sure?"),
                     message: Text("Once deleted, this account is not recoverable."),
                     primaryButton: .destructive(Text("Delete")) {
                        delete()
                     },
                     secondaryButton: .cancel())
            })
            
            // MARK: Recover Account
            Button {
               let str = recoverAccount?.name?.dropLast(10)
               recoverAccount?.name = String(str ?? "")
               recoverAccount?.isRetired = false
               do {
                  try viewContext.save()
               } catch {
                  let nsError = error as NSError
                  fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
               }
               checkRetired()
            } label: {
               ZStack {
                  Rectangle()
                     .font(.headline)
                     .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                     .frame(height: 55)
                     .cornerRadius(10)
                     .padding(.horizontal)
                  Text("Recover")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            }
            .padding(.bottom, 10)
         }
      }
      .navigationTitle("Retired Accounts")
      .onAppear {
         checkRetired()
      }
   }
   private func delete() {
      viewContext.perform {
         viewContext.delete(recoverAccount ?? AccountEntity())
         do {
            try viewContext.save()
         } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
         checkRetired()
      }
   }
   private func checkRetired() {
      hasRetired = false
      for a in accounts {
         if a.isRetired {
            if hasRetired == false {
               recoverAccount = a
            }
            hasRetired = true
         }
      }
   }
}

//struct ARecoveryView_Previews: PreviewProvider {
//   static var previews: some View {
//      ARecoveryView()
//   }
//}

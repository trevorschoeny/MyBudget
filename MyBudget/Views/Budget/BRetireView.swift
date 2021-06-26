//
//  BPeriodView.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/21/21.
//

import SwiftUI

struct BRetireView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: BudgetEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.userOrder, ascending: true), NSSortDescriptor(keyPath: \BudgetEntity.date, ascending: true)], animation: .default)
   private var budgets: FetchedResults<BudgetEntity>
   
   @State var inputBudget: BudgetEntity?
   @State var inputFunds: Double = 0
   
   @State var fundArr: [String] = []
   @State var fundNumArr: [Double] = []
   
   @State var total = 0.0
   @State var numBudgets = 0
   
   @Environment(\.presentationMode) var isPresented
   
   var body: some View {
      NavigationView {
         VStack {
            List {
               VStack(alignment: .leading) {
                  HStack(spacing: 0) {
                     Text("You have ")
                     if inputFunds == 0 {
                        if total - fundNumArr.reduce(0, +) >= 0 {
                           Text("$" + String(total - fundNumArr.reduce(0, +)))
                              .font(.title3)
                              .foregroundColor(.green)
                        } else {
                           Text("$" + String(total - fundNumArr.reduce(0, +)))
                              .font(.title3)
                              .foregroundColor(.red)
                        }
                     } else {
                        if inputFunds - fundNumArr.reduce(0, +) >= 0 {
                           Text("$" + String(inputFunds - fundNumArr.reduce(0, +)))
                              .font(.title3)
                              .foregroundColor(.green)
                        } else {
                           Text("$" + String(inputFunds - fundNumArr.reduce(0, +)))
                              .font(.title3)
                              .foregroundColor(.red)
                        }
                     }
                     Text(" remaining funds.")
                  }
                  Text("Allocate them, or continue.")
                     .font(.footnote)
                     .foregroundColor(.gray)
               }
               ForEach (0..<budgets.count) { i in
                  HStack {
                     Text(budgets[i].name! + ": ")
                     Spacer()
                     Text("$")
                     TextField("0.00", text: $fundArr[i])
                        .keyboardType(.decimalPad)
                        .onChange(of: fundArr[i]) { _ in
                           fundNumArr[i] = Double(fundArr[i]) ?? 0.0
                        }
                     
                  }
               }
            }
            
            // MARK: Cancel Button
            Button(action: {
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Start New Period Button
            VStack {
               Button(action: {
                  if inputBudget == nil {
                     for i in 0..<budgets.count {
                        addNewPeriod(budget: budgets[i])
                        budgets[i].extraAmount = Double(fundArr[i]) ?? 0.0
                        budgets[i].balance = budgets[i].budgetAmount + budgets[i].extraAmount
                     }
                  } else {
                     for i in 0..<budgets.count {
                        if budgets[i] == inputBudget {
                           addNewPeriod(budget: budgets[i])
                           budgets[i].extraAmount = Double(fundArr[i]) ?? 0.0
                           budgets[i].balance = total - fundNumArr.reduce(0, +)
                        } else {
                           budgets[i].extraAmount += Double(fundArr[i]) ?? 0.0
                           budgets[i].balance += Double(fundArr[i]) ?? 0.0
                        }
                     }
                  }
                  do {
                     try viewContext.save()
                  } catch {
                     let nsError = error as NSError
                     fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                  }
                  self.isPresented.wrappedValue.dismiss()
               }, label: {
                  ZStack {
                     Rectangle()
                        .font(.headline)
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                        .frame(height: 55)
                        .cornerRadius(10)
                        .padding(.horizontal)
                     Text("Retire Budget")
                        .font(.headline)
                        .foregroundColor(.white)
                  }
               })
               .padding(.bottom, 10)
            }
         }
         .navigationTitle("Retire Budget")
      }
      .onAppear(perform: {
         for b in budgets {
            total += b.balance
            numBudgets += 1
         }
         if inputBudget != nil {
            total = inputBudget?.balance ?? 0
         }
         fundArr = [String](repeating: "", count: numBudgets)
         fundNumArr = [Double](repeating: 0, count: numBudgets)
      })
   }
   private func addNewPeriod(budget: BudgetEntity) {
      let newPeriod = PeriodEntity(context: viewContext)
      newPeriod.budgetAmount = budget.budgetAmount
      newPeriod.date = Date()
      newPeriod.endBalance = budget.balance
      newPeriod.extraAmount = budget.extraAmount
      newPeriod.budget = budget
      do {
         try viewContext.save()
      } catch {
         let nsError = error as NSError
         fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
   }
}

struct BRetireView_Previews: PreviewProvider {
   static var previews: some View {
      BRetireView()
   }
}

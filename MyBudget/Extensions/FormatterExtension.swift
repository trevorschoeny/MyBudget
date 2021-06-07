//
//  F.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/7/21.
//

import Foundation

extension Formatter {
   static let number: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      formatter.negativePrefix = "($"
      formatter.negativeSuffix = ")"
      return formatter
   }()
}

func formatterFunction(number: Double) -> String {
    Formatter.number.string(for: number) ?? ""
}

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()

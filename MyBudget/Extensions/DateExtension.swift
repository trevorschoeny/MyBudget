//
//  DateExtension.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/6/21.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}

public func daysUntil(inputDate: Date) -> DateComponents {
   let userDate = Calendar.current.dateComponents([.day, .month, .year], from: inputDate.startOfDay)
    
    let userDateComponents = DateComponents(calendar: Calendar.current, year: userDate.year!, month: userDate.month!, day: userDate.day!).date!
    
   let daysUntil = Calendar.current.dateComponents([.day], from: Date().startOfDay, to: userDateComponents)
    
    return daysUntil
}

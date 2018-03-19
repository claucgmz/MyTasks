//
//  Date+Format.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

extension Date {
  func toString(withFormat format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    
    return dateFormatter.string(from: self)
  }
  
  func toString(withLocale locale: String, timeStyle: DateFormatter.Style = .none ) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = timeStyle
    dateFormatter.locale = Locale(identifier: locale)
    
    return dateFormatter.string(from: self)
  }
  
  var dayOfWeek: String {
    let dateFormatter = DateFormatter()
    let currentWeekday = Calendar.current.component(.weekday, from: self)
    
    return dateFormatter.weekdaySymbols[currentWeekday]
  }
  
  var startOfDay: Date {
    return Calendar.current.startOfDay(for: self)
  }
  
  var endOfDay: Date {
    let components = DateComponents(day: 1, second: -1)
    return Calendar.current.date(byAdding: components, to: self.startOfDay)!
  }
  
  var nextDay: Date {
    let components = DateComponents(day: 1)
    return Calendar.current.date(byAdding: components, to: self)!
  }
}

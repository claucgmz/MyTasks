//
//  DateType.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

enum DateType: String {
  case today
  case tomorrow
  case later
  case pastDueDate
  
  func getPosition() -> Int {
    switch self {
    case .today:
      return 0
    case .tomorrow:
      return 1
    case .later:
      return 2
    case .pastDueDate:
      return 3
    }
  }
}

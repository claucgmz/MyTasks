//
//  TaskList.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class TaskList {
  var name = ""
  var color = "white"
  var iconName = "No Icon"
  var items = [TaskItem]()
  
  init(name: String) {
    self.name = name
  }
  
  func countUncheckedItems() -> Int {
    return items.reduce(0) {count, item in
      count + (item.checked ? 0 : 1)
    }
  }
  
}

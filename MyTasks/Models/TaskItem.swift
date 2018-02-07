//
//  TaskItem.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class TaskItem {
  var itemID: Int
  var text = ""
  var checked = false
  var dueDate = Date()
  var shouldRemind = false
  var deleted = false
  
  func toogleCheckmark() {
    self.checked = !checked
  }
  
}


//
//  TaskList.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class TaskList {
  var name = ""
  var color = UIColor.ColorPicker.americanRiver
  var icon: CategoryIcon
  var items = [TaskItem]()
  
  init(name: String, icon: CategoryIcon = .bam) {
    self.name = name
    self.icon = icon
  }
  
  func countUncheckedItems() -> Int {
    return items.reduce(0) { count, item in
      count + (item.checked ? 0 : 1)
    }
  }
}

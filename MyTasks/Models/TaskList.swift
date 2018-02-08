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
  
  static var icons = ["bam", "cherry", "christmastree", "christmastreestar", "coffeecup", "cupcake", "department", "doraemon", "dratini", "dwarf", "easteregg", "emptybox", "halloweencandy", "home", "penguin", "pennywise", "pie", "pin", "pokeball", "pokemon", "sphere", "stapler", "supermario", "taco", "thriller", "trainticket", "vampire", "vegetarianfood", "witchhat"]
  
  init(name: String) {
    self.name = name
  }
  
  func countUncheckedItems() -> Int {
    return items.reduce(0) {count, item in
      count + (item.checked ? 0 : 1)
    }
  }
}

//
//  TaskListView.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/22/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import RealmSwift

class TaskListView {
  enum DateType: String {
    case today
    case tomorrow
    case later
    case pastDueDate
  }
  
  var type: DateType = .today
  var tasks: Results<TaskItem>!
  
  init(type: DateType, tasks: Results<TaskItem>) {
    self.type = type
    self.tasks = tasks
  }
}

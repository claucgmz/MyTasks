//
//  TaskListView.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/22/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class TaskListView {
  var type: DateType = .today
  var tasks = [Task]()
  
  init(type: DateType, tasks: [Task]) {
    self.type = type
    self.tasks = tasks
  }
}

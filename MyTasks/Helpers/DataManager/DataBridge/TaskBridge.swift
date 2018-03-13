//
//  TaskBridge.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/9/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//
struct TaskBridge {
  static func save(_ task: Task) {
    TaskDataHelper.save(task)
  }

  static func get(tasklist: Tasklist, by dateType: DateType, completionHandler: @escaping ([Task]) -> Void) {
    TaskDataHelper.get(from: tasklist.id, by: dateType, completionHandler: { data in
      var tasks = [Task]()
      for snData in data {
        if let taskData = snData.value as? [String: Any] {
          var task = Task(with: taskData)
          if task.deleted == false {
            task.tasklistId = tasklist.id
            tasks.append(task)
          }
        }
        completionHandler(tasks)
      }
    })
  }
}

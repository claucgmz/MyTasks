//
//  TaskData.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/9/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

struct TaskData {
  var id: String = ""
  var text: String = ""
  var date: Int = 0
  var checked = false
  var deleted = false
  var tasklistId: String = ""
  
  init(id: String, text: String, date: Int, checked: Bool, deleted: Bool, tasklistId: String) {
    self.id = id
    self.text = text
    self.date = date
    self.checked = checked
    self.deleted = deleted
    self.tasklistId = tasklistId
  }
  
  init(with data: [String: Any]) {
    guard let id = data["id"] as? String else {
      return
    }
    guard let text = data["text"] as? String else {
      return
    }
    guard let date = data["dueDate"] as? Double else {
      return
    }
    guard let checked = data["checked"] as? Bool else {
      return
    }
    guard let deleted = data["deleted"] as? Bool else {
      return
    }
    
    self.id = id
    self.text = text
    self.date = Int(date)
    self.checked = checked
    self.deleted = deleted
  }
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "text": text,
      "dueDate": date,
      "checked": checked,
      "deleted": deleted
    ]
  }
}

struct TaskBridge {
  static func save(_ task: Task) {
    let taskData = toTaskData(task)
    print(taskData)
    TaskDataHelper.create(taskData)
  }

  static func get(tasklist: Tasklist, by dateType: DateType, completionHandler: @escaping ([Task]) -> Void) {
    TaskDataHelper.get(from: tasklist.id, by: dateType, completionHandler: { data in
      var tasks = [Task]()
      for snData in data {
        if let task = snData.value as? [String: Any] {
          var taskData = TaskData(with: task)
          taskData.tasklistId = tasklist.id
          if taskData.deleted == false {
            tasks.append(toTask(taskData))
          }
        }
        completionHandler(tasks)
      }
    })
  }
  
  static func toTaskData(_ task: Task) -> TaskData {
    return TaskData(id: task.id, text: task.text, date: Int(task.dueDate.timeIntervalSince1970),
                    checked: task.checked, deleted: task.deleted, tasklistId: task.tasklistId)
  }
  
  static func toTask(_ taskData: TaskData) -> Task {
    return Task(id: taskData.id, text: taskData.text, date: Date(timeIntervalSince1970: Double(taskData.date)),
                checked: taskData.checked, tasklistId: taskData.tasklistId)
  }
}

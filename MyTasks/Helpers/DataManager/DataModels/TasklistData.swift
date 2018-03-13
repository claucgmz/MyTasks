//
//  TasklistData.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/9/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//
import UIKit

struct TasklistData {
  var id: String = ""
  var name: String = ""
  var icon: String = ""
  var hex: String = ""
  
  init(id: String, name: String, icon: String, hex: String) {
    self.id = id
    self.name = name
    self.icon = icon
    self.hex = hex
  }
  
  init(with data: [String: Any]) {
    guard let id = data["id"] as? String else {
      return
    }
    guard let name = data["name"] as? String else {
     return
    }
    guard let icon = data["icon"] as? String else {
      return
    }
    guard let hex = data["hex"] as? String else {
      return
    }
    
    self.id = id
    self.name = name
    self.icon = icon
    self.hex = hex
  }
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "name": name,
      "icon": icon,
      "hex": hex
    ]
  }
}

struct TasklistBridge {
  static func save(_ tasklist: Tasklist) {
    let tasklistData = toTasklistData(tasklist)
    TasklistDataHelper.create(tasklistData)
  }
  
  static func delete(_ tasklist: Tasklist) {
    let tasklistData = toTasklistData(tasklist)
    TasklistDataHelper.delete(tasklistData)
  }
  
  static func getAll(completionHandler: @escaping ([Tasklist]) -> Void) {
    TasklistDataHelper.getAll(completionHandler: { data in
      var tasklists = [Tasklist]()
      for snData in data {
        if let tasklist = snData.value as? [String: Any] {
          let tasklistData = TasklistData(with: tasklist)
          tasklists.append(toTasklist(tasklistData))
        }
      }
      completionHandler(tasklists)
    })
  }
  
  static func getTotalToBeDoneToday(completionHandler: @escaping (Int) -> Void) {
    TasklistDataHelper.getAll(completionHandler: { data in
      for snData in data {
        if let tasklist = snData.value as? [String: Any] {
          let tasklistData = TasklistData(with: tasklist)
          TaskDataHelper.get(from: tasklistData.id, by: .today, completionHandler: { data in
            var total = 0
            for snData in data {
              if let task = snData.value as? [String: Any] {
                let taskData = TaskData(with: task)
                if taskData.deleted == false {
                  total += 1
                }
              }
              completionHandler(total)
            }
          })
        }
      }
    })
  }
  
  static func toTasklistData(_ tasklist: Tasklist) -> TasklistData {
    return TasklistData(id: tasklist.id, name: tasklist.name, icon: tasklist.icon.rawValue, hex: tasklist.color.toHexString)
  }
  
  static func toTasklist(_ tasklistData: TasklistData) -> Tasklist {
    return Tasklist(id: tasklistData.id, name: tasklistData.name, icon: CategoryIcon(rawValue: tasklistData.icon)!, color: UIColor(hex: tasklistData.hex))
  }
}

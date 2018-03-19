//
//  DataHelper+Task.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/13/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import ObjectMapper

extension DataHelper {
  static func save(_ task: Task) {
    taskRef.child(task.tasklistId).child(FirebasePath.added.rawValue)
      .child(task.id).setValue(task.toDictionary())
  }
  
  static func delete(_ task: Task) {
    taskRef.child(task.tasklistId).child(FirebasePath.added.rawValue)
      .child(task.id).removeValue()
  }
  
  static func softDelete(_ task: Task) {
    task.deleted = true
    delete(task)
    taskRef.child(task.tasklistId).child(FirebasePath.deleted.rawValue)
      .child(task.id).setValue(task.toDictionary())
  }
  
  static func getTasks(from tasklist: Tasklist, for dateType: DateType, completionHandler: @escaping ([Task]) -> Void) {
    var dateRef = taskRef.child(tasklist.id)
      .child(FirebasePath.added.rawValue).queryOrdered(byChild: FirebasePath.dueDate.rawValue)
    
    let today = Date().startOfDay, tomorrow = today.nextDay
    
    switch dateType {
    case .today:
      dateRef = dateRef.queryStarting(atValue: today.timeIntervalSince1970)
        .queryEnding(atValue: today.endOfDay.timeIntervalSince1970)
    case .tomorrow:
      dateRef = dateRef.queryStarting(atValue: tomorrow.timeIntervalSince1970)
        .queryEnding(atValue: tomorrow.endOfDay.timeIntervalSince1970)
    case .later:
      dateRef = dateRef.queryStarting(atValue: tomorrow.nextDay.timeIntervalSince1970)
    default:
      dateRef = dateRef.queryEnding(atValue: today.timeIntervalSince1970)
    }
    
    dateRef.observe(.value, with: { snapshot in
      var tasks = [Task]()
      let data = snapshot.value as? [String: Any] ?? [:]
      var taskDictArray: [[String: Any]] = []
      for snData in data {
        if var taskData = snData.value as? [String: Any] {
          taskData["tasklistId"] = tasklist.id
          taskDictArray.append(taskData)
        }
      }
      tasks = Mapper<Task>().mapArray(JSONArray: taskDictArray)
      completionHandler(tasks)
    })
  }
  
  static func getTotalTasks(from tasklist: Tasklist, totalType: Tasklist.TotalType, completionHandler: @escaping (Int) -> Void) {
    switch totalType {
    case .checked:
     taskRef.child(tasklist.id).child(FirebasePath.added.rawValue)
        .queryOrdered(byChild: FirebasePath.checked.rawValue)
        .queryEqual(toValue: true)
        .observe(.value, with: { snapshot in
          completionHandler(Int(snapshot.childrenCount))
        })
    default:
     taskRef.child(tasklist.id).child(FirebasePath.added.rawValue)
        .observe(.value, with: { snapshot in
          completionHandler(Int(snapshot.childrenCount))
        })
    }
  }
}

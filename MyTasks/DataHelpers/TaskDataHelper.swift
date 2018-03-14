//
//  TaskDataHelper.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/9/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class TaskDataHelper {
  static var databaseRef = Database.database().reference()
  static var tasksRef = databaseRef.child(FirebasePath.tasks.rawValue)
  
  static func save(_ object: Task) {
    tasksRef.child(object.tasklistId).child(FirebasePath.added.rawValue).child(object.id).setValue(object.toDictionary())
  }
  
  static func delete(_ object: Task) {
    tasksRef.child(object.tasklistId).child(FirebasePath.added.rawValue).child(object.id).removeValue()
  }
  
  static func softDelete(_ object: Task) {
    TaskDataHelper.delete(object)
    object.deleted = true
    tasksRef.child(object.tasklistId).child(FirebasePath.deleted.rawValue).child(object.id).setValue(object.toDictionary())
  }
  
  static func get(tasklist: Tasklist, by dateType: DateType, completionHandler: @escaping ([Task]) -> Void) {
    var dateRef = tasksRef.child(tasklist.id).child(FirebasePath.added.rawValue).queryOrdered(byChild: FirebasePath.dueDate.rawValue)
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
      let data = snapshot.value as? [String: Any] ?? [:]
      var tasks = [Task]()
      for snData in data {
        if let taskData = snData.value as? [String: Any] {
          let task = Task(with: taskData)
          task.tasklistId = tasklist.id
          tasks.append(task)
        }
      }
      completionHandler(tasks)
    })
  }
  
  static func getTotal(_ object: Tasklist, totalType: TotalType, completionHandler: @escaping (Int) -> Void) {
    if totalType == .checked {
      tasksRef.child(object.id).child(FirebasePath.added.rawValue)
        .queryOrdered(byChild: FirebasePath.checked.rawValue)
        .queryEqual(toValue: true)
        .observe(.value, with: { snapshot in
          completionHandler(Int(snapshot.childrenCount))
        })
    } else {
      tasksRef.child(object.id).child(FirebasePath.added.rawValue)
        .observe(.value, with: { snapshot in
          completionHandler(Int(snapshot.childrenCount))
        })
    }
  }
}

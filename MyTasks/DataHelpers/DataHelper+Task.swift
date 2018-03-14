//
//  DataHelper+Task.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/13/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

extension DataHelper {
  static func save(_ task: Task) {
    databaseRef.child(task.mainPath).child(task.tasklistId).child(FirebasePath.added.rawValue)
      .child(task.id).setValue(task.toDictionary())
  }
  
  static func delete(_ task: Task) {
    databaseRef.child(task.mainPath).child(task.tasklistId).child(FirebasePath.added.rawValue)
      .child(task.id).removeValue()
  }
  
  static func softDelete(_ task: Task) {
    task.deleted = true
    delete(task)
    databaseRef.child(task.mainPath).child(task.tasklistId).child(FirebasePath.deleted.rawValue)
      .child(task.id).setValue(task.toDictionary())
  }
  
  static func getTasks(from tasklist: Tasklist, for dateType: DateType, completionHandler: @escaping ([Task]) -> Void) {
    var dateRef = databaseRef.child(FirebasePath.tasks.rawValue).child(tasklist.id)
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
  
  static func getTotalTasks(from tasklist: Tasklist, totalType: Tasklist.TotalType, completionHandler: @escaping (Int) -> Void) {
    switch totalType {
    case .checked:
      databaseRef.child(FirebasePath.tasks.rawValue).child(tasklist.id).child(FirebasePath.added.rawValue)
        .queryOrdered(byChild: FirebasePath.checked.rawValue)
        .queryEqual(toValue: true)
        .observe(.value, with: { snapshot in
          completionHandler(Int(snapshot.childrenCount))
        })
    default:
      databaseRef.child(FirebasePath.tasks.rawValue).child(tasklist.id).child(FirebasePath.added.rawValue)
        .observe(.value, with: { snapshot in
          completionHandler(Int(snapshot.childrenCount))
        })
    }
  }
}

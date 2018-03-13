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

class TaskDataHelper: DataHelperProtocol {
  typealias T = Task
  static var databaseRef = Database.database().reference()
  static var tasksRef = databaseRef.child("tasks")
  
  static func save(_ object: Task) {
    tasksRef.child(object.tasklistId).child("added").child(object.id).setValue(object.toDictionary())
  }

  static func delete(_ object: Task) {
    tasksRef.child(object.tasklistId).child("added").child(object.id).removeValue()
  }
  
  static func softDelete(_ object: Task) {
    let deletedObject = object
    deletedObject.deleted = true
    tasksRef.child(deletedObject.tasklistId).child("deleted").child(deletedObject.id).setValue(deletedObject.toDictionary())
  }
  
  static func get(from tasklistId: String, completionHandler: @escaping ([String: Any]) -> Void) {
    tasksRef.child(tasklistId).child("added").queryOrdered(byChild: "dueDate")
    .observeSingleEvent(of: .value, with: { snapshot in
      let data = snapshot.value as? [String: Any] ?? [:]
      completionHandler(data)
    })
  }
  
  static func get(from tasklistId: String, by dateType: DateType, completionHandler: @escaping ([String: Any]) -> Void) {
    var dateRef = tasksRef.child(tasklistId).child("added").queryOrdered(byChild: "dueDate")
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
      completionHandler(data)
    })
  }
  
  static func getTotal(_ object: Tasklist, totalType: TotalType, completionHandler: @escaping (Int) -> Void) {
    if totalType == .checked {
      tasksRef.child(object.id).child("added")
        .queryOrdered(byChild: "checked")
        .queryEqual(toValue: true)
        .observe(.value, with: { snapshot in
        completionHandler(Int(snapshot.childrenCount))
      })
    } else {
      tasksRef.child(object.id).child("added")
        .observe(.value, with: { snapshot in
          completionHandler(Int(snapshot.childrenCount))
        })
    }
  }
}

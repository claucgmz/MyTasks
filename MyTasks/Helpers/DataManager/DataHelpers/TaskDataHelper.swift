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
  typealias T = TaskData
  static var databaseRef = Database.database().reference()

  static func create(_ object: TaskData) {
    databaseRef.child("tasks").child(object.tasklistId).child(object.id).setValue(object.toDictionary())
  }
  
  static func update(_ object: TaskData) {
    
  }
  
  static func delete(_ object: TaskData) {
 
  }
  
  static func get(from tasklistId: String, by dateType: DateType, completionHandler: @escaping ([String: Any]) -> Void) {
    var dateRef = databaseRef.child("tasks").child(tasklistId).queryOrdered(byChild: "dueDate")
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
    
    dateRef.observeSingleEvent(of: .value, with: { snapshot in
      let data = snapshot.value as? [String: Any] ?? [:]
      completionHandler(data)
    })
  }
  
  static func get(from tasklistId: String, completionHandler: @escaping ([String: Any]) -> Void) {
    databaseRef.child("tasks").child(tasklistId)
      .queryOrdered(byChild: "deleted")
      .queryEqual(toValue: false)
      .observeSingleEvent(of: .value, with: { snapshot in
      let data = snapshot.value as? [String: Any] ?? [:]
      completionHandler(data)
    })
  }
}

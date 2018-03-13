//
//  TasklistDataHelper.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/9/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class TasklistDataHelper: DataHelperProtocol {
  typealias T = Tasklist
  static var databaseRef = Database.database().reference()
  static var tasklistsRef = databaseRef.child("tasklists")
  static var tasksRef = databaseRef.child("tasks")
  
  static func save(_ object: Tasklist) {
    if let userId = UserBridge.current() {
      tasklistsRef.child(userId).child(object.id).setValue(object.toDictionary())
    }
  }
  
  static func delete(_ object: Tasklist) {
    if let userId = UserBridge.current() {
      tasklistsRef.child(userId).child(object.id).removeValue()
      tasksRef.child(object.id).removeValue()
    }
  }
  
  static func getAll(completionHandler: @escaping ([String: Any]) -> Void) {
    if let userId = UserBridge.current() {
      tasklistsRef.child(userId).observe(.value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        completionHandler(data)
      })
    }
  }
}

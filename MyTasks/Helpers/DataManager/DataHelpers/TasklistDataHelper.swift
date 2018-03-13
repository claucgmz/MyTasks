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
  typealias T = TasklistData
  static var databaseRef = Database.database().reference()
  
  static func create(_ object: TasklistData) {
    if let userId = UserBridge.current() {
      databaseRef.child("tasklists").child(userId).child(object.id).setValue(object.toDictionary())
    }
  }
  
  static func update(_ object: TasklistData) {
  }
  
  static func delete(_ object: TasklistData) {
    if let userId = UserBridge.current() {
      databaseRef.child("tasklists").child(userId).child(object.id).removeValue()
      databaseRef.child("tasks").child(object.id).removeValue()
    }
  }
  
  static func getAll(completionHandler: @escaping ([String: Any]) -> Void) {
    if let userId = UserBridge.current() {
      databaseRef.child("tasklists").child(userId).observe(.value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        completionHandler(data)
      })
    }
  }

}

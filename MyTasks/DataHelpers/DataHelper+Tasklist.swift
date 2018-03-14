//
//  DataHelper+Tasklist.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/13/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

extension DataHelper {
  static func save(_ tasklist: Tasklist) {
    if let userId = user() {
      databaseRef.child(tasklist.mainPath).child(userId).child(tasklist.id).setValue(tasklist.toDictionary())
    }
  }
  
  static func delete(_ tasklist: Tasklist) {
    if let userId = user() {
      databaseRef.child(tasklist.mainPath).child(userId).child(tasklist.id).removeValue()
      databaseRef.child(FirebasePath.tasks.rawValue).child(tasklist.id).removeValue()
    }
  }
  
  static func getTasklists(completionHandler: @escaping ([Tasklist]) -> Void) {
    if let userId = user() {
      databaseRef.child(FirebasePath.tasklists.rawValue).child(userId).observe(.value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        var tasklists = [Tasklist]()
        for snData in data {
          if let tasklistData = snData.value as? [String: Any] {
            let tasklist = Tasklist(with: tasklistData)
            tasklist.setTotal(completionHandler: nil)
            tasklists.append(tasklist)
          }
        }
        completionHandler(tasklists)
      })
    }
  }
}

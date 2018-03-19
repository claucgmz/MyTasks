//
//  DataHelper+Tasklist.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/13/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import ObjectMapper

extension DataHelper {
  static func save(_ tasklist: Tasklist) {
    guard let userId = AuthServer.user() else {
      return
    }
    tasklistRef.child(userId).child(tasklist.id).setValue(tasklist.toDictionary())
  }
  
  static func delete(_ tasklist: Tasklist) {
    guard let userId = AuthServer.user() else {
      return
    }
    tasklistRef.child(userId).child(tasklist.id).removeValue()
    taskRef.child(tasklist.id).removeValue()
  }
  
  static func getTasklists(completionHandler: @escaping([Tasklist]) -> Void) {
    var tasklists = [Tasklist]()
    guard let userId = AuthServer.user() else {
      completionHandler(tasklists)
      return
    }
    tasklistRef.child(userId).observe(.value, with: { snapshot in
      let data = snapshot.value as? [String: Any] ?? [:]
      var tasklistDictArray: [[String: Any]] = []
      for snData in data {
        if let tasklistData = snData.value as? [String: Any] {
          tasklistDictArray.append(tasklistData)
        }
      }
      tasklists = Mapper<Tasklist>().mapArray(JSONArray: tasklistDictArray)
      completionHandler(tasklists)
    })
    
  }
}

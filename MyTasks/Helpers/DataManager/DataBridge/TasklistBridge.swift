//
//  TasklistBridge.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/9/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//
import UIKit

struct TasklistBridge {
  static func save(_ tasklist: Tasklist) {
    TasklistDataHelper.save(tasklist)
  }
  
  static func delete(_ tasklist: Tasklist) {
    TasklistDataHelper.delete(tasklist)
  }
  
  static func getAll(completionHandler: @escaping ([Tasklist]) -> Void) {
    TasklistDataHelper.getAll(completionHandler: { data in
      var tasklists = [Tasklist]()
      for snData in data {
        if let tasklistData = snData.value as? [String: Any] {
          tasklists.append(Tasklist(with: tasklistData))
        }
      }
      completionHandler(tasklists)
    })
  }
  
  static func getTotalToBeDoneToday(completionHandler: @escaping (Int) -> Void) {
//    TasklistDataHelper.getAll(completionHandler: { data in
//      for snData in data {
//        if let tasklist = snData.value as? [String: Any] {
//          let tasklistData = TasklistData(with: tasklist)
//          TaskDataHelper.get(from: tasklistData.id, by: .today, completionHandler: { data in
//            var total = 0
//            for snData in data {
//              if let task = snData.value as? [String: Any] {
//                let taskData = TaskData(with: task)
//                if taskData.deleted == false {
//                  total += 1
//                }
//              }
//              completionHandler(total)
//            }
//          })
//        }
//      }
//    })
  }
}

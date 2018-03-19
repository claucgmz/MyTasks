//
//  Task.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import ObjectMapper

class Task: DataModel {
  var mainPath: String = FirebasePath.tasks.rawValue
  var id = UUID().uuidString
  var text = ""
  var dueDate = Date()
  var checked = false
  var deleted = false
  var tasklistId = ""
  
  var dateType: DateType {
    let today = Date()
    switch dueDate {
    case ...today.startOfDay:
      return .pastDueDate
    case today.startOfDay...today.endOfDay:
      return .today
    case today.nextDay.startOfDay...today.nextDay.endOfDay:
      return .tomorrow
    default:
      return .later
    }
  }
  
  required init?(map: Map) {
    
  }
  
  init(text: String, date: Date, tasklistId: String) {
    self.text = text
    self.dueDate = date
    self.tasklistId = tasklistId
  }
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "text": text,
      "dueDate": dueDate.timeIntervalSince1970,
      "checked": checked,
      "deleted": deleted
    ]
  }
}

extension Task: Mappable {
  func mapping(map: Map) {
    tasklistId <- map["tasklistId"]
    id         <- map["id"]
    text       <- map["text"]
    dueDate    <- (map["dueDate"], DateTransform())
    //map[dueDate]= Date(timeIntervalSince1970: date)
    checked    <- map["checked"]
    deleted    <- map["deleted"]
  }
}

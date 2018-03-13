//
//  Task.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class Task {
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
  
  init(id: String, text: String, date: Date) {
    self.text = text
    self.dueDate = date
  }
  
  init(id: String, text: String, date: Date, checked: Bool, tasklistId: String) {
    self.id = id
    self.text = text
    self.dueDate = date
    self.checked = checked
    self.tasklistId = tasklistId
  }
  
  init(text: String, date: Date, tasklistId: String) {
    self.text = text
    self.dueDate = date
    self.tasklistId = tasklistId
  }
  
  init(with data: [String: Any]) {
    guard let id = data["id"] as? String else {
      return
    }
    guard let text = data["text"] as? String else {
      return
    }
    guard let date = data["dueDate"] as? Double else {
      return
    }
    guard let checked = data["checked"] as? Bool else {
      return
    }
    guard let deleted = data["deleted"] as? Bool else {
      return
    }
    
    self.id = id
    self.text = text
    self.dueDate = Date(timeIntervalSince1970: date)
    self.checked = checked
    self.deleted = deleted
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

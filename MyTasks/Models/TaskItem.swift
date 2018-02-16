//
//  TaskItem.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class TaskItem: Object {
  dynamic var text = ""
  dynamic var checked = false
  dynamic var dueDate = Date()
  dynamic var shouldRemind = false
  dynamic var deleted = false
  
  // MARK: - Init
  convenience init(text: String, date: Date) {
    self.init()
    self.text = text
    self.dueDate = date
  }
  
  override static func indexedProperties() -> [String] {
    return ["dueDate"]
  }
  
  func add(to tasklist: TaskList) {
    tasklist.add(task: self)
  }
  
  func update(text: String, date: Date) {
    do{
      try RealmService.shared.realm.write {
        self.text = text
        self.dueDate = date
      }
    } catch {
      print(error)
    }
  }
  
  func toogleCheckmark() {
    do{
      try RealmService.shared.realm.write {
        self.checked = !checked
      }
    } catch {
      print(error)
    }
  }
  
  func softDelete() {
    do{
      try RealmService.shared.realm.write {
        self.deleted = true
      }
    } catch {
      print(error)
    }
  }
  
}


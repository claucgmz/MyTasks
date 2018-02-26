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
  dynamic var tasklist: TaskList?
  dynamic var id = UUID().uuidString
  dynamic var text = ""
  dynamic var dueDate = Date()
  dynamic var checked = false
  dynamic var deleted = false
  
  // MARK: - Init
  convenience init(text: String, date: Date) {
    self.init()
    self.text = text
    self.dueDate = date
  }
  
  // MARK: - Meta
  override class func primaryKey() -> String? {
    return "id"
  }
  
  override static func indexedProperties() -> [String] {
    return ["dueDate"]
  }
  
  func add(to tasklist: TaskList) {
    RealmService.add(object: self, set: { self.tasklist = tasklist }, update: true)
  }
  
  // MARK: - Manage list methods
  func update(text: String, date: Date, moveTo tasklist: TaskList? = nil) {
    RealmService.add(object: self, set: {
      if let totasklist = tasklist {
        self.tasklist = totasklist
      }
      self.text = text
      self.dueDate = date }, update: true)
  }
  
  func complete() {
    RealmService.add(object: self, set: {
      self.checked = !checked
    }, update: true)
  }
  
  func softDelete() {
    RealmService.add(object: self, set: {
      self.deleted = true
    }, update: true)
  }
}


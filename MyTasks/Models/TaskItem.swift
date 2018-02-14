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
  
  func toogleCheckmark() {
    let realm = RealmService.shared.realm
    do{
      try realm.write {
        self.checked = !checked
      }
    } catch {
      print(error)
    }
  }
  
  
  func remove() {
    RealmService.shared.delete(self)
  }
  
  func delete() {
    let realm = RealmService.shared.realm
    do{
      try realm.write {
        self.deleted = true
      }
    } catch {
      print(error)
    }
  }
  
}


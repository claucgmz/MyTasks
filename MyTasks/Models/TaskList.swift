//
//  TaskList.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers class TaskList: Object {
  
  // MARK: - Properties
  //dynamic var user: User?
  dynamic var id = UUID().uuidString
  dynamic var name = ""
  dynamic var hex = ""
  dynamic var categoryIcon = CategoryIcon.bam.rawValue
  var items = List<TaskItem>()
  
  var color: UIColor {
    return UIColor(hex: hex)
  }
  
  var icon: CategoryIcon {
    get {
      return CategoryIcon(rawValue: categoryIcon)!
    }
    set {
      categoryIcon = newValue.rawValue
    }
  }
  
  // MARK: - Init
  convenience init(name: String, icon: CategoryIcon, color: UIColor) {
    self.init()
   //self.user = User.getLoggedUser()
    self.name = name
    self.icon = icon
    self.hex = color.toHexString
  }
  
  // MARK: - Meta
  override class func primaryKey() -> String? {
    return "id"
  }
  
  override static func indexedProperties() -> [String] {
    return ["user"]
  }
  
  func countUncheckedItems() -> Int {
    return items.reduce(0) { count, item in
      count + (item.checked ? 0 : 1)
    }
  }
  
  func add(task: TaskItem) {
    let realm = RealmService.shared.realm
    do{
      try realm.write {
        items.append(task)
        print("add item to db")
      }
    } catch {
      print(error)
    }
  }
  
  func update(task: TaskItem, at index: Int) {
    let realm = RealmService.shared.realm
    do{
      try realm.write {
        items[index] = task
      }
    } catch {
      print(error)
    }
  }
}

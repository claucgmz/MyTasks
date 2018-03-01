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
  dynamic var user: User?
  dynamic var id = UUID().uuidString
  dynamic var name = ""
  dynamic var hex = ""
  dynamic var categoryIcon = CategoryIcon.bam.rawValue
  let taskItems = LinkingObjects(fromType: TaskItem.self, property: "tasklist")
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
  var tasks: Results<TaskItem> {
    return taskItems.filter("deleted = 0")
  }
  
  // MARK: - Init
  convenience init(name: String, icon: CategoryIcon, color: UIColor) {
    self.init()
    self.name = name
    self.icon = icon
    self.hex = color.toHexString
  }
  
  // MARK: - Meta
  override class func primaryKey() -> String? {
    return "id"
  }
  
  var pendingTasksToday: Results<TaskItem> {
    let today = Date()
    return taskItems.filter("checked = 0 AND dueDate BETWEEN %@", [today.startOfDay, today.endOfDay])
  }
  
  var tasksByDate: [TaskListView] {
    var tasksbydate = [TaskListView](), dateTypes: [TaskListView.DateType] = [.today, .tomorrow, .later, .pastDueDate]
    for dateType in dateTypes {
      let filtered = filterTasks(by: dateType)
      if  filtered.count > 0 {
        tasksbydate.append(TaskListView(type: dateType, tasks: filtered.sorted(byKeyPath: "dueDate", ascending: true)))
      }
    }
    return tasksbydate
  }
  
  func progressPercentage() -> Double {
    let totalDone = tasks.filter("checked = 1").count
    if tasks.count > 0 {
      return Double(totalDone) / Double(tasks.count)
    }
    return 0.0
  }
  
  private func filterTasks(by dateType: TaskListView.DateType) -> Results<TaskItem> {
    let today = Date().startOfDay, tomorrow = today.nextDay
    switch dateType {
    case .today:
      return tasks.filter("dueDate BETWEEN %@", [today, today.endOfDay])
    case .tomorrow:
      return tasks.filter("dueDate BETWEEN %@", [tomorrow, tomorrow.endOfDay])
    case .later:
      return tasks.filter("dueDate > %@", tomorrow.nextDay)
    default:
      return tasks.filter("dueDate < %@", today)
    }
  }
  
  // MARK: - Manage tasklist methods
  func update(name: String, icon: CategoryIcon, color: UIColor) {
    RealmService.performUpdate(object: self, set: {
      self.name = name
      self.icon = icon
      self.hex = color.toHexString
    })
  }
}

extension TaskList: BasicStorageFunctions {
  func add() {
    guard let user = RealmService.getLoggedUser() else {
      return
    }
    RealmService.performUpdate(object: self, set: { self.user = user }, update: true)
  }
  
  func hardDelete() {
    let items = RealmService.realm.objects(TaskItem.self).filter("tasklist = %@", self)
    RealmService.hardDelete(objects: items)
    RealmService.hardDelete(object: self)
  }
}

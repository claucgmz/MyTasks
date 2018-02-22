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
  
  var tasks: Results<TaskItem> {
    return items.filter("deleted = 0")
  }
  
  var pendingTasksToday: Results<TaskItem> {
    let today = Date()
    let todayStart = today.startOfDay
    let todayEnd = today.endOfDay
    
    return items.filter("checked = 0 AND dueDate BETWEEN %@", [todayStart, todayEnd])
  }
  
  var tasksByDate: [TaskListView] {
    var tasksbydate = [TaskListView]()
    let today = Date()
    let todayStart = today.startOfDay
    let todayEnd = today.endOfDay
    
    var filtered = TaskListView(type: .today, tasks: tasks.filter("dueDate BETWEEN %@", [todayStart, todayEnd]))
    if filtered.tasks.count > 0 {
      tasksbydate.append(filtered)
    }
    
    let tomorrow = todayStart.nextDay
    let tomorrowEnd = tomorrow.endOfDay
    
    filtered = TaskListView(type: .tomorrow, tasks: tasks.filter("dueDate BETWEEN %@", [tomorrow, tomorrowEnd]))
    if filtered.tasks.count > 0 {
      tasksbydate.append(filtered)
    }
    
    let later = tomorrow.nextDay
    filtered = TaskListView(type: .later, tasks: tasks.filter("dueDate > %@", later))
    if filtered.tasks.count > 0 {
      tasksbydate.append(filtered)
    }
    
    filtered = TaskListView(type: .pastDueDate, tasks: tasks.filter("dueDate < %@", todayStart))
    if filtered.tasks.count > 0 {
      tasksbydate.append(filtered)
    }
    
    return tasksbydate
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
  
  // MARK: - Meta
  func progressPercentage() -> Double {
    let totalDone = tasks.filter("checked = 1").count
    if tasks.count > 0 {
      return Double(totalDone) / Double(tasks.count)
    }
    return 0.0
  }

  // MARK: - Manage tasklist methods
  func add(task: TaskItem) {
    do{
      try RealmService.shared.realm.write {
        items.append(task)
      }
    } catch {
      print(error)
    }
  }
  
  func remove(task: TaskItem) {
    do{
      try RealmService.shared.realm.write {
        let index = self.items.index(of: task)
        self.items.remove(at: index!)
      }
    } catch {
      print(error)
    }
  }
  
  func update(name: String, icon: CategoryIcon, color: UIColor) {
    do{
      try RealmService.shared.realm.write {
        self.name = name
        self.hex = color.toHexString
        self.icon = icon
      }
    } catch {
      print(error)
    }
  }
}

extension TaskList: BasicStorageFunctions {
  func add() {
    let user = User.getLoggedUser()
    do{
      try RealmService.shared.realm.write {
        user?.tasklists.append(self)
      }
    } catch {
      print(error)
    }
  }
  
  func hardDelete() {
    do{
      try RealmService.shared.realm.write {
        for item in items {
          realm?.delete(item)
        }
        realm?.delete(self)
      }
    } catch {
      print(error)
    }
  }
}

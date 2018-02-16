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
  
  var tasksByDate: (order: [String], tasks: [Results<TaskItem>]) {
    var tasksbydate = [Results<TaskItem>]()
    var orderby = [String]()
    
    let today = Date()
    let todayStart = today.startOfDay
    let todayEnd = today.endOfDay
    
    var filterTasks = tasks.filter("dueDate BETWEEN %@", [todayStart, todayEnd])
    if filterTasks.count > 0 {
      tasksbydate.append(filterTasks)
      orderby.append("Today")
    }
    
    let tomorrow = todayStart.nextDay
    let tomorrowEnd = tomorrow.endOfDay
    
    filterTasks = tasks.filter("dueDate BETWEEN %@", [tomorrow, tomorrowEnd])
    if filterTasks.count > 0 {
      tasksbydate.append(filterTasks)
      orderby.append("Tomorrow")
    }
    
    let later = tomorrow.nextDay
    filterTasks = tasks.filter("dueDate > %@", later)
    if filterTasks.count > 0 {
      tasksbydate.append(filterTasks)
      orderby.append("Later")
    }
    
    filterTasks = tasks.filter("dueDate < %@", todayStart)
    if filterTasks.count > 0 {
      tasksbydate.append(filterTasks)
      orderby.append("PastDueDate")
    }
    
    return (order: orderby, tasks: tasksbydate)
  }
  
  
  func progressPercentage() -> Double {
    let totalDone = tasks.filter("checked = 1").count
    if tasks.count > 0 {
      return Double(totalDone) / Double(tasks.count)
    }
    return 0.0
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

  func add(task: TaskItem) {
    do{
      try RealmService.shared.realm.write {
        items.append(task)
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

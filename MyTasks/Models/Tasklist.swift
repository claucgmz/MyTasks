//
//  Tasklist.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

enum TotalType {
  case all
  case checked
  case today
}

class Tasklist {
  var id = UUID().uuidString
  var name = ""
  var icon = CategoryIcon.bam
  var color = UIColor.ColorPicker.cityLights
  var totalTasks = 0
  var totalChecked = 0
  var tasksViews = [TaskListView]()
  
  var progressPercentage: Double {
    if !tasksViews.isEmpty {
      return Double(totalChecked) / Double(totalTasks)
    }
    return 0.0
  }
  
  init(id: String, name: String, icon: CategoryIcon, color: UIColor) {
    self.id = id
    self.name = name
    self.icon = icon
    self.color = color
  }
  
  init(name: String, icon: CategoryIcon, color: UIColor) {
    self.name = name
    self.icon = icon
    self.color = color
  }
  
  init(with data: [String: Any]) {
    guard let id = data["id"] as? String else {
      return
    }
    guard let name = data["name"] as? String else {
      return
    }
    guard let icon = data["icon"] as? String else {
      return
    }
    guard let hex = data["hex"] as? String else {
      return
    }
    
    self.id = id
    self.name = name
    self.icon = CategoryIcon(rawValue: icon)!
    self.color = UIColor(hex: hex)
  }
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "name": name,
      "icon": icon.rawValue,
      "hex": color.toHexString
    ]
  }
  
  func setTotal() {
    TasklistBridge.getTotal(self, totalType: .all, completionHandler: { total in
      self.totalTasks = total
    })
    
    TasklistBridge.getTotal(self, totalType: .checked, completionHandler: { total in
      self.totalChecked = total
    })
  }
  
  func getTasks(for dateType: DateType, order: Int, completionHandler: @escaping () -> Void) {
    TaskBridge.get(tasklist: self, by: dateType, completionHandler: { tasks in
      if !tasks.isEmpty {
        let view = TaskListView(type: dateType, tasks: tasks)
        let total = self.tasksViews.count
        if let index = self.getIndexPath(for: dateType) {
          self.tasksViews[index] = view
        } else if total > order {
          self.tasksViews.insert(view, at: order)
        } else if !self.tasksViews.isEmpty && total == order {
          self.tasksViews.insert(view, at: total-1)
        } else {
          self.tasksViews.append(view)
        }
      } else {
        if let index = self.getIndexPath(for: dateType) {
          self.tasksViews.remove(at: index)
        }
      }
      completionHandler()
    })
  }
  
  private func getIndexPath(for dateType: DateType) -> Int? {
    guard let index = tasksViews.index(where: { tasklistView in
      tasklistView.type == dateType }) else {
        return nil
    }
    return index
  }
}

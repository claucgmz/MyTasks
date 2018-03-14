//
//  Tasklist.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class Tasklist: DataModel {
  enum TotalType {
    case all
    case checked
    case today
  }
  
  var mainPath: String = FirebasePath.tasklists.rawValue
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
  
  func setTotal(completionHandler: (() -> Void)?) {
    DataHelper.getTotalTasks(from: self, totalType: .all, completionHandler: { total in
      self.totalTasks = total
      guard let handler = completionHandler else { return }
      handler()
    })
    
    DataHelper.getTotalTasks(from: self, totalType: .checked, completionHandler: { total in
      self.totalChecked = total
      guard let handler = completionHandler else { return }
      handler()
    })

  }
  
  func getTasks(for dateType: DateType, completionHandler: @escaping () -> Void) {
    DataHelper.getTasks(from: self, for: dateType, completionHandler: { tasks in
      let position = dateType.getPosition()
      if !tasks.isEmpty {
        let view = TaskListView(type: dateType, tasks: tasks)
        let total = self.tasksViews.count
        if let index = self.getIndexPath(for: dateType) {
          self.tasksViews[index] = view
        } else if total >= position {
          self.tasksViews.insert(view, at: position)
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

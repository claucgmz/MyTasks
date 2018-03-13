//
//  Tasklist.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

struct Tasklist {
  var id = UUID().uuidString
  var name = ""
  var icon = CategoryIcon.bam
  var color = UIColor.ColorPicker.cityLights
  
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
}

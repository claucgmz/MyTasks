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

  init(name: String, icon: CategoryIcon, color: UIColor) {
    self.name = name
    self.icon = icon
    self.color = color
  }
  
  init(id: String, name: String, icon: CategoryIcon, color: UIColor) {
    self.id = id
    self.name = name
    self.icon = icon
    self.color = color
  }
}

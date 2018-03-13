//
//  TaskListCell.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class TaskListCell: UITableViewCell {
  @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  func configure(with tasklist: Tasklist, isSelected: Bool) {
    iconImage.image = UIImage(named: tasklist.icon.rawValue)
    nameLabel.text = tasklist.name
    setCurrent(isSelected)
  }
  
  func setCurrent(_ set: Bool) {
    if set {
      accessoryType = .checkmark
    } else {
      accessoryType = .none
    }
  }
}

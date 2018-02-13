//
//  TaskCell.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
  @IBOutlet weak var checkboxButton: UIButton!
  @IBOutlet weak var taskTextLabel: UILabel!
  
  func configure(with task: TaskItem) {
    checkboxButton.isEnabled = task.checked
    taskTextLabel.text = task.text
  }
}

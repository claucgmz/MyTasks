//
//  TextFieldCell.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
  @IBOutlet weak var taskNameLabel: UILabel!
  @IBOutlet weak var taskNameTextField: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    taskNameLabel.text = NSLocalizedString("task_to_perform", comment: "")
  }
}

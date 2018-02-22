//
//  DueDateCell.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/14/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class DueDateCell: UITableViewCell {
  @IBOutlet weak var dueDateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    dueDateLabel.text = NSLocalizedString("due_date", comment: "")
  }
}

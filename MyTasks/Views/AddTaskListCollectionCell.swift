//
//  AddTaskListCollectionCell.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class AddTaskListCollectionCell: UICollectionViewCell {
  @IBOutlet weak var addText: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    addText.text = NSLocalizedString("add_list", comment: "")
  }
}

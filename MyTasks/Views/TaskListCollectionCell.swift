//
//  TaskListCollectionCell.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class TaskListCollectionCell: UICollectionViewCell {
  @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var counterLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  func configure(withTaskList list: TaskList) {
    iconImage.image = UIImage(named: list.iconName)
    nameLabel.text = list.name
    counterLabel.text = "\(list.countUncheckedItems()) Tasks"
  }
  
}

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
  @IBOutlet weak var moreButton: UIButton!
  @IBOutlet weak var counterLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var progressBar: UIProgressView!
  @IBOutlet weak var progressLabel: UILabel!
  
  func configure(with tasklist: TaskList, index: Int) {
    iconImage.image = UIImage(named: tasklist.icon.rawValue)
    iconImage.tintImageColor(color: tasklist.color)
    nameLabel.text = tasklist.name
    counterLabel.text = "\(tasklist.tasks.count) Tasks"
    moreButton.tag = index
    updateProgressBar(with: tasklist)
  }
  
  private func updateProgressBar(with tasklist: TaskList) {
    progressBar.progressTintColor = tasklist.color
    let progress = tasklist.progressPercentage()
    progressBar.setProgress(Float(progress), animated: true)
    progressLabel.text = "\(Int(progress * 100))%"
  }
}

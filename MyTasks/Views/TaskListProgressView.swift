//
//  TaskListProgressView.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/14/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class TaskListProgressView: UIView {
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var iconView: UIView!
  @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var tasksCounterLabel: UILabel!
  @IBOutlet weak var taskListNameLabel: UILabel!
  @IBOutlet weak var progressBar: UIProgressView!
  @IBOutlet weak var progressLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func configure(with tasklist: TaskList) {
    configureIcon(with: tasklist.icon, color: tasklist.color)
    tasksCounterLabel.text = "\(tasklist.tasks.count) \(NSLocalizedString("tasks", comment: ""))"
    updateProgressBar(with: tasklist)
    taskListNameLabel.text = tasklist.name
  }
  
  private func commonInit() {
    Bundle.main.loadNibNamed("TaskListProgressView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
  private func configureIcon(with icon: CategoryIcon, color: UIColor) {
    let icon = UIImage(named: icon.rawValue)
    iconImage.image = icon
    iconImage.tintImageColor(color: color)
    iconView.layer.borderWidth = 1.5
    iconView.layer.borderColor = color.cgColor
    iconView.roundCorners(withRadius: iconView.layer.bounds.width/2)
  }
  
  private func updateProgressBar(with tasklist: TaskList) {
    progressBar.progressTintColor = tasklist.color
    let progress = tasklist.progressPercentage()
    progressBar.setProgress(Float(progress), animated: true)
    progressLabel.text = "\(Int(progress * 100))%"
  }
}

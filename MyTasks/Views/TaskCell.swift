//
//  TaskCell.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
  
  @IBOutlet weak var checkboxView: UIView!
  @IBOutlet weak var deleteView: UIView!
  
  @IBOutlet private weak var checkbox: UIImageView!
  @IBOutlet private weak var taskTextLabel: UILabel!
  
  private let checked = UIImage(named: "checked")
  private let unchecked = UIImage(named: "unchecked")
  
  func configure(with task: TaskItem) {
    toogleCheckmark(with: task.checked)
    taskTextLabel.text = task.text
  }
  
  func toogleCheckmark(with isChecked: Bool) {
    if isChecked {
      checkbox.image = checked
      deleteView.isHidden = false
      strikeThroughText(strike: true)
    } else {
      checkbox.image = unchecked
      deleteView.isHidden = true
      strikeThroughText(strike: false)
    }
  }
  
  private func strikeThroughText(strike: Bool) {
    guard let text = taskTextLabel.text else {
      return
    }
    
    let textRange = NSMakeRange(0, text.count)
    let attributedText = NSMutableAttributedString(string: text)
    
    if strike {
      attributedText.addAttribute(.strikethroughStyle,
                                  value: NSUnderlineStyle.styleSingle.rawValue,
                                  range: textRange)
    } else {
      attributedText.removeAttribute(.strikethroughStyle, range: textRange)
    }
    taskTextLabel.attributedText = attributedText
  }
}

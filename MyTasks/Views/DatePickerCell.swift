//
//  DatePickerCell.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class DatePickerCell: UITableViewCell {
  @IBOutlet weak var datePicker: UIDatePicker!
  
  func configure(with date: Date) {
    datePicker.setDate(date, animated: false)
  }
}

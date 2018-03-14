//
//  UITableViewHeaderFooterView+ReusableId.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/27/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

extension UITableViewHeaderFooterView {
  static var reusableId: String {
    return String(describing: self)
  }
}

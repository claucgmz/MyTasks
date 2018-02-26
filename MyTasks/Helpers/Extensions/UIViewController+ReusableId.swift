//
//  UIViewController+ReusableId.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

extension UIViewController {
  static var reusableId: String {
    return String(describing: self)
  }
}


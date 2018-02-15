//
//  UIButton+State.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/13/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

extension UIButton {
  func didEnable(_ enable: Bool) {
    self.isEnabled = enable
    if enable {
      self.alpha = 1.0
    } else {
      self.alpha = 0.6
    }
  }
}

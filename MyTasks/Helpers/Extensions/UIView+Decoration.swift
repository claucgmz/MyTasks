//
//  UIView+Decoration.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/8/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

extension UIView {
  func roundCorners(withRadius radius: CGFloat) {
    self.layer.cornerRadius = radius
    self.layer.masksToBounds = true
  }
}

//
//  UIImageView+Tint.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/7/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

extension UIImageView {
  func tintImageColor(color : UIColor) {
    self.image = self.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    self.tintColor = color
  }
}

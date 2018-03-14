//
//  ButtonIBInspectable.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/23/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class ButtonIBInspectable: UIButton {
  
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
}

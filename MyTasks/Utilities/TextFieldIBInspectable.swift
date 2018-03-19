//
//  TextFieldIBInspectable.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/15/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class TextFieldIBInspectable: UITextField {
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  
  @IBInspectable var leftInset: CGFloat = 0 {
    didSet {
      leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftInset, height: frame.height))
      leftViewMode = .always
    }
  }
}

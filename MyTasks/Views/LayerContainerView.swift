//
//  LayerContainerView.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/8/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class LayerContainerView: UIView {
  
  override public class var layerClass: Swift.AnyClass {
    return CAGradientLayer.self
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    guard let gradientLayer = self.layer as? CAGradientLayer else { return }
    gradientLayer.colors = [
      UIColor.ColorPicker.firstDate.cgColor,
      UIColor.ColorPicker.pinkGlamour.cgColor,
      UIColor.ColorPicker.orangeville.cgColor
    ]
  }
}

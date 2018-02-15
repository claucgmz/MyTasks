//
//  UIImageView+Decoration.swift
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
  
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    let shadowFrame = CGRect(x: self.frame.origin.x+2, y: self.frame.origin.y+2, width: self.frame.width+2, height: self.frame.height+2)
    let shadowView = UIView(frame: shadowFrame)
    
    shadowView.layer.masksToBounds = false
    shadowView.layer.shadowColor = color.cgColor
    shadowView.layer.shadowOpacity = opacity
    shadowView.layer.shadowOffset = offSet
    shadowView.layer.shadowRadius = radius
    shadowView.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: shadowView.frame.size.width / 2).cgPath
    shadowView.layer.shouldRasterize = true
    shadowView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    shadowView.layer.cornerRadius = shadowView.frame.size.width / 2
    self.superview?.insertSubview(shadowView, belowSubview: self)
  }
}

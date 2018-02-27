//
//  IconPickerCollectionCell.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/7/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class IconPickerCollectionCell: UICollectionViewCell {
  @IBOutlet weak var iconImage: UIImageView!
  
  func configure(withIcon icon: CategoryIcon, isSelected: Bool, color: UIColor) {
    if let icon = UIImage(named: icon.rawValue) {
      iconImage.image = icon
    }
    
    if isSelected {
      iconImage.tintImageColor(color: color)
    } else {
      iconImage.tintImageColor(color: color.withAlphaComponent(0.5))
    }
  }
}

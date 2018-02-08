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
  
  func configure(withIcon icon: String, color: UIColor?) {
    if let icon = UIImage(named: icon) {
      iconImage.image = icon
    }
    
    if let color = color {
      iconImage.tintImageColor(color: color)
    }
  }
}

//
//  ColorPickerCollectionCell.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/7/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class ColorPickerCollectionCell: UICollectionViewCell {
  @IBOutlet private weak var colorView: UIView!
  
  func configure(withColor color: UIColor) {
    colorView.backgroundColor = color
    colorView.layer.cornerRadius = colorView.frame.size.width / 2
    colorView.clipsToBounds = true
  }
}

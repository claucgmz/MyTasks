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
  @IBOutlet weak var selectedView: UIView!
  
  func configure(withColor color: UIColor) {
    selectedView.isHidden = true
    selectedView.roundCorners(withRadius: selectedView.frame.size.width / 2)
    colorView.backgroundColor = color
    colorView.roundCorners(withRadius: colorView.frame.size.width / 2)
  }
}

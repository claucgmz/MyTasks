//
//  UICollectionViewCell+ReuseableId.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/8/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
  static var reusableId: String {
    return String(describing: self)
  }
}

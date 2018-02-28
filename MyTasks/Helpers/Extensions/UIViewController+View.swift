//
//  UIViewController+View.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/28/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

extension UIViewController {
  func adjustView(with height: CGFloat, visibleKeyboard: Bool) {
    let newHeight = visibleKeyboard == true ? view.frame.height - height : view.frame.height + height
    let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: newHeight)
    view.frame = frame
  }
}

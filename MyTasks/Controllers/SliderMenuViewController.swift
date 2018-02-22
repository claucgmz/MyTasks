//
//  SliderMenuViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/19/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SliderMenuViewController: SlideMenuController {
  override func awakeFromNib() {
    if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Main") {
      self.mainViewController = controller
    }
    
    if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Left") {
      self.leftViewController = controller
    }
    super.awakeFromNib()
  }
}

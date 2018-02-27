//
//  AlertView.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/27/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class AlertView: NSObject {
  class func show(view: UIViewController, title: String, message: String = "", actions: [UIAlertAction], style: UIAlertControllerStyle ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    for action in actions {
      alert.addAction(action)
    }
    view.present(alert, animated: true)
  }
  
  class func action(title: String, style: UIAlertActionStyle = .default, handler: (() -> Void)? = nil) -> UIAlertAction {
    return UIAlertAction(title: title, style: style, handler: handler != nil ? { action in handler!() }: nil)
  }
}

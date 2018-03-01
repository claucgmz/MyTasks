//
//  UserManager.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/27/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import UIKit

class UserManager {
  func loginWithFacebook(viewController: UIViewController, onSuccess: @escaping() -> Void, onFailure: @escaping(Error?) -> Void) {
    FacebookManager().login(viewController, onSuccess: { data in
      User(with: data).add()
      FacebookManager().logout()
      onSuccess()
    }, onFailure: {
      error in
      print("Error: \(String(describing: error?.localizedDescription))")
    })
  }
  func logout() {
    RealmService.logOutUser()
  }
}

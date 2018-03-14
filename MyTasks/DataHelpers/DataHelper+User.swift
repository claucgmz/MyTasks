//
//  DataHelper+User.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/13/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

extension DataHelper {
  static func user() -> String? {
    if let user = Auth.auth().currentUser {
      return user.uid
    }
    return nil
  }
}

//
//  UserBridge.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/9/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

struct UserBridge {
  static func save(_ user: User) {
    UserDataHelper.save(user)
  }
  
  static func current() -> String? {
    return UserDataHelper.current()
  }
}

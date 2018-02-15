//
//  UserDefaults+LogIn.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

extension UserDefaults {
  
  enum UserDefaultsKeys: String {
    case isLoggedIn
    case userId
  }
  
  func setIsLoggedIn(value: Bool) {
    set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    synchronize()
  }
  
  func isLoggedIn() -> Bool {
    return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
  }
  
  func setUserId(with value: Int) {
    set(value, forKey: UserDefaultsKeys.userId.rawValue)
    synchronize()
  }
  
  func getUserId() -> Int {
    return integer(forKey: UserDefaultsKeys.userId.rawValue)
  }
}

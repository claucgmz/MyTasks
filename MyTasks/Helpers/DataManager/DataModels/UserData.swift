//
//  UserData.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/9/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

struct UserData {
  var id: String
  var email: String = ""
  var firstName: String = ""
  var lastName: String = ""
  var facebookId: String? = ""
  
  func toDictionary() -> [String: Any?] {
    return [
      "id": id,
      "email": email,
      "fistName": firstName,
      "lastName": lastName,
      "facebookId": facebookId
    ]
  }
}

struct UserBridge {
  static func save(_ user: UserData) {
    UserDataHelper.create(user)
  }
  
  static func save(_ user: User) {
    let userData = toUserData(user)
    UserDataHelper.create(userData)
  }
  
  static func current() -> String? {
    return UserDataHelper.current()
  }
  
  static func toUserData(_ user: User) -> UserData {
    return UserData(id: user.id, email: user.email, firstName: user.firstName, lastName: user.lastName, facebookId: user.facebookId)
  }
  
  static func toUser(_ userData: UserData) -> User {
    return User(id: userData.id, firstName: userData.firstName, lastName: userData.lastName, email: userData.email)
  }
}

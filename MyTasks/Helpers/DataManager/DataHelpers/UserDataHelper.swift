//
//  UserDataHelper.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/9/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class UserDataHelper: DataHelperProtocol {
  typealias T = User
  static var databaseRef = Database.database().reference()
  
  static func save(_ object: User) {
    databaseRef.child("users").child(object.id).setValue(object.toDictionary())
  }

  static func delete(_ object: User) {
    
  }
  
  static func current() -> String? {
    if let user = Auth.auth().currentUser {
      return user.uid
    }
    return nil
  }
}

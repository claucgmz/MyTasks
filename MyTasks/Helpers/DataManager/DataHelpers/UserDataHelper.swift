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
  typealias T = UserData
  static var databaseRef = Database.database().reference()
  
  static func create(_ object: UserData) {
    databaseRef.child("users").child(object.id).setValue(object.toDictionary())
  }
  
  static func update(_ object: UserData) {
    
  }
  
  static func delete(_ object: UserData) {
    
  }
  
  static func getAll(completionHandler: @escaping ([UserData]) -> Void) {
    
  }
  
  static func current() -> String? {
    if let user = Auth.auth().currentUser {
      return user.uid
    }
    return nil
  }
}

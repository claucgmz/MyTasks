//
//  DataHelper.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/13/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DataHelper {
  static var databaseRef = Database.database().reference()
  static let userRef = Database.database().reference(withPath: FirebasePath.users.rawValue)
  static let tasklistRef = Database.database().reference(withPath: FirebasePath.tasklists.rawValue)
  static let taskRef = Database.database().reference(withPath: FirebasePath.tasks.rawValue)
  
  static func save(_ object: DataModel) {
    databaseRef.child(object.mainPath).child(object.id).setValue(object.toDictionary())
  }
}

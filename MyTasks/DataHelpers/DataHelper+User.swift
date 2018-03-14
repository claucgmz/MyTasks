//
//  DataHelper+User.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/13/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import Firebase

extension DataHelper {
  static func getUser(completionHandler: @escaping (User?) -> Void) {
    if let currentUser = Auth.auth().currentUser {
       databaseRef.child(FirebasePath.users.rawValue).child(currentUser.uid).observe(.value, with: { snapshot in
        let data = snapshot.value as? [String: Any] ?? [:]
        completionHandler(User(with: data))
       })
    }
  }
}

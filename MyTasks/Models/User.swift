//
//  User.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class User {
  var id = ""
  var displayName = "Stranger"
  var email = ""
  var facebookId = ""
  var totalTasksForToday = 0
  
  var imageURL: URL {
    return URL(string: "https://graph.facebook.com/\(facebookId)/picture?type=large")!
  }
  
  init(id: String, email: String, displayName: String, facebookId: String) {
    self.id = id
    self.email = email
    self.displayName = displayName
    self.facebookId = facebookId
  }
}

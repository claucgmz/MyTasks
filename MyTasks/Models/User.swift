//
//  User.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

struct User {
  var id = UUID().uuidString
  var firstName = ""
  var lastName = ""
  var email = ""
  var facebookId = ""
  
  var imageURL: URL {
    return URL(string: "https://graph.facebook.com/\(id)/picture?type=large")!
  }
  
  var totalTasksForToday: Int {
    return 0
//    return tasklists.reduce(0) { _, tasklist in
//      tasklist.pendingTasksToday.count
//    }
  }
  
  init(id: String, firstName: String, lastName: String, email: String) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
  }
  
  init(with facebookData: [String: Any]?) {
    if let id = facebookData?["id"] as? String {
      self.id = id
    }
    if let firstName = facebookData?["first_name"] as? String {
      self.firstName = firstName
    }
    if let lastName = facebookData?["last_name"] as? String {
      self.lastName = lastName
    }
  }
}

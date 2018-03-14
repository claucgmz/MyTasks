//
//  User.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class User: DataModel {
  var mainPath: String = FirebasePath.users.rawValue
  var id = UUID().uuidString
  var firstName = ""
  var lastName = ""
  var email = ""
  var facebookId = ""
  var totalTasksForToday = 0
  var imageURL: URL {
    return URL(string: "https://graph.facebook.com/\(id)/picture?type=large")!
  }
  
  init(firstName: String, lastName: String, email: String, facebookId: String) {
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.facebookId = facebookId
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
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "email": email,
      "fistName": firstName,
      "lastName": lastName,
      "facebookId": facebookId
    ]
  }
}

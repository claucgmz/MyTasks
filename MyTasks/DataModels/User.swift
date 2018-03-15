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
  var id = ""
  var firstName = "Guest"
  var lastName = ""
  var email = ""
  var facebookId = ""
  var totalTasksForToday = 0
  
  var imageURL: URL {
    return URL(string: "https://graph.facebook.com/\(facebookId)/picture?type=large")!
  }
  
  init(id: String, email: String) {
    self.id = id
    self.email = email
  }
  
  init(with data: [String: Any]) {
    print(data)
    guard let id = data["id"] as? String else {
      return
    }
    guard let firstName = data["firstName"] as? String else {
      return
    }
    guard let lastName = data["lastName"] as? String else {
      return
    }
    guard let email = data["email"] as? String else {
      return
    }
    guard let facebookId = data["facebookId"] as? String else {
      return
    }
    
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.facebookId = facebookId
  }
  
  init(withFacebook data: [String: Any]?) {
    if let facebookId = data?["id"] as? String {
      self.facebookId = facebookId
    }
    if let firstName = data?["first_name"] as? String {
      self.firstName = firstName
    }
    if let lastName = data?["last_name"] as? String {
      self.lastName = lastName
    }
  }
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "facebookId": facebookId
    ]
  }
}

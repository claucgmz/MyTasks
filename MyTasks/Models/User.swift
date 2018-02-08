//
//  User.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class User: Object {
  
  // MARK: - Properties
  dynamic var id = 0
  dynamic var firstName = ""
  dynamic var lastName = ""
  dynamic var timestamp = Date().timeIntervalSinceReferenceDate
  
  var imageURL: String {
    return "https://graph.facebook.com/\(id)/picture?type=large"
  }
  
  // MARK: - Init
  convenience init(with data: [String : Any]?) {
    self.init()
    
    if let id = data?["id"] as? String {
      self.id = (id as NSString).integerValue
    }
    
    if let firstName = data?["first_name"] as? String {
      self.firstName = firstName
    }
    
    if let lastName = data?["last_name"] as? String {
      self.lastName = lastName
    }

  }
  
  // MARK: - Meta
  override class func primaryKey() -> String? {
    return "id"
  }
}

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
  
  // MARK: - Init
  convenience init(with data: [String : Any]?) {
    self.init()
    
    if let id = data?["id"] as? String {
      self.id = (id as NSString).integerValue
    }
    
    if let firstName = data?["name"] as? String {
      self.firstName = firstName
    }
  }
  
  // MARK: - Meta
  override class func primaryKey() -> String? {
    return "id"
  }
  
  // MARK: - Etc
  
  private static func createUser(in realm: Realm, with user: User) -> User {
    try! realm.write {
      realm.add(user)
    }
    
    return user
  }
  
  @discardableResult static func user(in realm: Realm, with user: User) -> User {
    return realm.object(ofType: User.self, forPrimaryKey: user.id) ?? createUser(in: realm, with: user)
  }
}

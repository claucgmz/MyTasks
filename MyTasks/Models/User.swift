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
  dynamic var isLoggedIn = false
  var tasklists = List<TaskList>()
  
  var imageURL: String {
    return "https://graph.facebook.com/\(id)/picture?type=large"
  }
  
  var totalTasksForToday: Int {
    var total = 0
    for tasklist in tasklists {
      total += tasklist.pendingTasksToday.count
    }
    return total
  }
  
  // MARK: - Init
  convenience init(with facebookData: [String : Any]?) {
    self.init()
    
    if let id = facebookData?["id"] as? String {
      self.id = (id as NSString).integerValue
    }
    
    if let firstName = facebookData?["first_name"] as? String {
      self.firstName = firstName
    }
    
    if let lastName = facebookData?["last_name"] as? String {
      self.lastName = lastName
    }
  }
  
  // MARK: - Meta
  override class func primaryKey() -> String? {
    return "id"
  }
  
  override static func indexedProperties() -> [String] {
    return ["isLoggedIn"]
  }
  
  // MARK: - Manage user methods
  
  static func getLoggedUser() -> User? {
    let user = RealmService.realm.objects(User.self).filter("isLoggedIn == true")
    return user.first
  }

  func logOut() {
    do{
      try RealmService.realm.write {
        self.isLoggedIn = false
      }
    } catch {
      print(error)
    }
  }
  
  func add(tasklist: TaskList) {
    do{
      try RealmService.realm.write {
        tasklists.append(tasklist)
      }
    } catch {
      print(error)
    }
  }
}

extension User: BasicStorageFunctions {
  func add() {
    isLoggedIn = true
    RealmService.add(object: self, update: true)
  }
  
  func hardDelete() {
    RealmService.hardDelete(object: self)
  }
}

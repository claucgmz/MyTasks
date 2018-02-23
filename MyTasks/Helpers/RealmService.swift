//
//  RealmService.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
  private init() {}
  static let shared = RealmService()
  static var realm = try! Realm()
  
  static func add(object: Object, set: () -> Void, update: Bool = false) {
    try! realm.write {
      set()
      realm.add(object, update: update)
    }
  }
  
  static func hardDelete(object: Object) {
    try! realm.write {
      realm.delete(object)
    }
  }
  
  static func hardDelete<T: Object>(objects: Results<T>) {
    try! realm.write {
      realm.delete(objects)
    }
  }
}

extension RealmService {
  static func logOut(user: User) {
    try! realm.write {
      user.isLoggedIn = false
    }
  }
  
  static func getLoggedUser() -> User? {
    let user = realm.objects(User.self).filter("isLoggedIn == true")
    return user.first
  }
  
  static func add(user: User, update: Bool = false) {
    add(object: user, set: {
      user.isLoggedIn = true
    }, update: update)
  }
}

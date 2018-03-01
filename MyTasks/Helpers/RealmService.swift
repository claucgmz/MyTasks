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
  static let shared = RealmService()
  static var realm = try! Realm()
  
  static func performUpdate(object: Object, set: () -> Void, update: Bool = true) {
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
  static func logOutUser() {
    try! realm.write {
      RealmService.getLoggedUser()?.isLoggedIn = false
    }
  }
  
  //que no sea opciona;l
  static func getLoggedUser() -> User? {
    let user = realm.objects(User.self).filter("isLoggedIn == true")
    return user.first
  }
  
  static func add(user: User, update: Bool = false) {
    RealmService.performUpdate(object: user, set: {
      user.isLoggedIn = true
    }, update: update)
  }
}

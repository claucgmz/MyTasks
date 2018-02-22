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
  
  static func add(object: Object, update: Bool = false) {
    try! realm.write {
      realm.add(object, update: update)
    }
  }
  
  static func hardDelete(object: Object) {
    try! realm.write {
      realm.delete(object)
    }
  }
}

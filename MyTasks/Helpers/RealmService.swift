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
  var realm = try! Realm()
}

//
//  DataModel.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/13/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

protocol DataModel {
  var id: String { get set }
  func toDictionary() -> [String: Any]
}

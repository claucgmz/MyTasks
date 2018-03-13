//
//  DataHelperProtocol.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/8/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//
import UIKit

protocol DataHelperProtocol {
  associatedtype T
  static func create(_ object: T)
  static func update(_ object: T)
  static func delete(_ object: T)
}

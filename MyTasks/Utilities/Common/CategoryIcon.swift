//
//  CategoryIcon.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/8/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

enum CategoryIcon: String {
  case bam
  case cherry
  case christmastree
  case christmastreestar
  case coffeecup
  case cupcake
  case department
  case doraemon
  case dratini
  case dwarf
  case easteregg
  case emptybox
  case halloweencandy
  case home
  case penguin
  case pennywise
  case pie
  case pin
  case pokeball
  case pokemon
  case sphere
  case stapler
  case supermario
  case taco
  case thriller
  case trainticket
  case vampire
  case vegetarianfood
  case witchhat
  
  var image: UIImage {
    return UIImage(named: self.rawValue)!
  }
  
  static var all: [CategoryIcon] {
    return [.bam, .cherry, .christmastree, .christmastreestar, .coffeecup, .cupcake, .department, .doraemon,
            .dratini, .dwarf, .easteregg, .emptybox, .halloweencandy, .home, .penguin, .pennywise,
            .pie, .pin, .pokeball, .pokemon, .sphere, .stapler, .supermario, .taco,
            .thriller, .trainticket, .vampire, .vegetarianfood, .witchhat]
  }
}

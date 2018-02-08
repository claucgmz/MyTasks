//
//  UIColor+ColorPicker.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/7/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(r: Int, g:Int , b:Int) {
    self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
  }
  
  struct ColorPicker {
    static var lightGreenishBlue: UIColor { return UIColor(r: 85, g: 239, b: 196) }
    static var fadedPoster: UIColor { return UIColor(r: 129, g: 236, b: 236) }
    static var greenDarnerTail: UIColor { return UIColor(r: 116, g: 185, b: 255) }
    static var shyMoment: UIColor { return UIColor(r: 162, g: 155, b: 254) }
    static var cityLights: UIColor { return UIColor(r: 223, g: 230, b: 233) }
    static var mintLeaf: UIColor { return UIColor(r: 0, g: 184, b: 148) }
    static var robinsEggBlue: UIColor { return UIColor(r: 0, g: 206, b: 201) }
    static var electronBlue: UIColor { return UIColor(r: 9, g: 132, b: 227) }
    static var exodusFruit: UIColor { return UIColor(r: 108, g: 92, b: 231) }
    static var soothingBreeze: UIColor { return UIColor(r: 178, g: 190, b: 195) }
    static var sourLemon: UIColor { return UIColor(r: 255, g: 234, b: 167) }
    static var firstDate: UIColor { return UIColor(r: 250, g: 177, b: 160) }
    static var pinkGlamour: UIColor { return UIColor(r: 255, g: 118, b: 117) }
    static var picoPink: UIColor { return UIColor(r: 253, g: 121, b: 168) }
    static var americanRiver: UIColor { return UIColor(r: 99, g: 110, b: 114) }
    static var brightYarrow: UIColor { return UIColor(r: 253, g: 203, b: 110) }
    static var orangeville: UIColor { return UIColor(r: 225, g: 112, b: 85) }
    static var chiGong: UIColor { return UIColor(r: 214, g: 48, b: 49) }
    static var prunusAvium: UIColor { return UIColor(r: 232, g: 67, b: 147) }
    static var draculaOrchid: UIColor { return UIColor(r: 45, g: 52, b: 54) }
    static var all: [UIColor] { return [lightGreenishBlue, fadedPoster, greenDarnerTail, shyMoment, cityLights, mintLeaf, robinsEggBlue, electronBlue, exodusFruit, soothingBreeze, sourLemon, firstDate, pinkGlamour, picoPink, americanRiver, brightYarrow, orangeville, chiGong, prunusAvium, draculaOrchid ]}
  }
}


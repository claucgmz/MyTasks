//
//  UIColor+ColorPicker.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/7/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0)
  }
  
  convenience init(hex: String) {
    let scanner = Scanner(string: hex)
    scanner.scanLocation = 0
    
    var rgbValue: UInt64 = 0
    
    scanner.scanHexInt64(&rgbValue)
    
    let r = (rgbValue & 0xff0000) >> 16
    let g = (rgbValue & 0xff00) >> 8
    let b = rgbValue & 0xff
    
    self.init(
      red: CGFloat(r) / 0xff,
      green: CGFloat(g) / 0xff,
      blue: CGFloat(b) / 0xff, alpha: 1
    )
  }
  
  var toHexString: String {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    self.getRed(&r, green: &g, blue: &b, alpha: &a)
    
    return String(
      format: "%02X%02X%02X",
      Int(r * 0xff),
      Int(g * 0xff),
      Int(b * 0xff)
    )
  }
  
  struct ColorPicker {
    static var lightGreenishBlue: UIColor { return UIColor(red: 85, green: 239, blue: 196) }
    static var fadedPoster: UIColor { return UIColor(red: 129, green: 236, blue: 236) }
    static var greenDarnerTail: UIColor { return UIColor(red: 116, green: 185, blue: 255) }
    static var shyMoment: UIColor { return UIColor(red: 162, green: 155, blue: 254) }
    static var cityLights: UIColor { return UIColor(red: 223, green: 230, blue: 233) }
    static var mintLeaf: UIColor { return UIColor(red: 0, green: 184, blue: 148) }
    static var robinsEggBlue: UIColor { return UIColor(red: 0, green: 206, blue: 201) }
    static var electronBlue: UIColor { return UIColor(red: 9, green: 132, blue: 227) }
    static var exodusFruit: UIColor { return UIColor(red: 108, green: 92, blue: 231) }
    static var soothingBreeze: UIColor { return UIColor(red: 178, green: 190, blue: 195) }
    static var sourLemon: UIColor { return UIColor(red: 255, green: 234, blue: 167) }
    static var firstDate: UIColor { return UIColor(red: 250, green: 177, blue: 160) }
    static var pinkGlamour: UIColor { return UIColor(red: 255, green: 118, blue: 117) }
    static var picoPink: UIColor { return UIColor(red: 253, green: 121, blue: 168) }
    static var americanRiver: UIColor { return UIColor(red: 99, green: 110, blue: 114) }
    static var brightYarrow: UIColor { return UIColor(red: 253, green: 203, blue: 110) }
    static var orangeville: UIColor { return UIColor(red: 225, green: 112, blue: 85) }
    static var chiGong: UIColor { return UIColor(red: 214, green: 48, blue: 49) }
    static var prunusAvium: UIColor { return UIColor(red: 232, green: 67, blue: 147) }
    static var draculaOrchid: UIColor { return UIColor(red: 45, green: 52, blue: 54) }
    static var all: [UIColor] { return [lightGreenishBlue, fadedPoster, greenDarnerTail, shyMoment, cityLights,
                                        mintLeaf, robinsEggBlue, electronBlue, exodusFruit, soothingBreeze, sourLemon,
                                        firstDate, pinkGlamour, picoPink, americanRiver, brightYarrow, orangeville, chiGong,
                                        prunusAvium, draculaOrchid ]}
  }
}

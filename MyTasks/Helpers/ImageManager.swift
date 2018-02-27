//
//  ImageDownloader.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/27/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import AlamofireImage

class ImageManager {
  static let shared = ImageManager()
  private let imageCache = AutoPurgingImageCache()
  
  func get(from url: String, completionHandler: @escaping(Image) -> Void) {
    let urlRequest = URLRequest(url: URL(string: url)!)
    
    guard let cachedAvatarImage = imageCache.image(for: urlRequest, withIdentifier: "avatar") else {
      download(from: url, completionHandler: { image  in
        let avatarImage = image.af_imageRoundedIntoCircle()
        self.imageCache.add(avatarImage, withIdentifier: "avatar")
        completionHandler(avatarImage)
      })
      return
    }
    
    completionHandler(cachedAvatarImage)
  }
  
  private func download(from url: String, completionHandler: @escaping(Image) -> Void) {
    let urlRequest = URLRequest(url: URL(string: url)!)
    ImageDownloader.default.download(urlRequest) { response in
      
      if let image = response.result.value {
        completionHandler(image)
      }
    }
  }
}

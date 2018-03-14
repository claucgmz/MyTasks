//
//  ImageManager.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/1/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import AlamofireImage

class ImageManager {
  static let shared = ImageManager()
  private let imageCache = AutoPurgingImageCache()
  
  func get(from url: URL, completionHandler: @escaping (Image) -> Void) {
    let urlRequest = URLRequest(url: url)
    guard let cachedAvatarImage = imageCache.image(for: urlRequest, withIdentifier: "avatar") else {
      ImageDownloader.default.download(urlRequest) { response in
        if let image = response.result.value {
          let avatarImage = image.af_imageRoundedIntoCircle()
          self.imageCache.add(avatarImage, withIdentifier: "avatar")
          completionHandler(avatarImage)
        }
      }
      return
    }
    completionHandler(cachedAvatarImage)
  }
}

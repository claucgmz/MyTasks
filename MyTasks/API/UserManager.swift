//
//  UserManager.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class UserManager {
  
  private init() {}
  static let shared = UserManager()
  
  func getImageFromURL(request: URL, onSuccess: @escaping (Data?) -> Void, onFailure: @escaping (Error?) -> Void){
    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { (data, response, error) in
      
      guard let data = data else{
        onFailure(error)
        return
      }
      
      onSuccess(data)
    }
    
    task.resume()
  }
}


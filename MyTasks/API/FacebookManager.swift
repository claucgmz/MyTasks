//
//  FacebookManager.swift
//  MyTasks
//
//  Created by Claudia Carrillo on 2/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import FacebookCore

class FacebookManager {
  
  let connection = GraphRequestConnection()
  
  func getUserInfo(onSuccess: @escaping ([String: Any]?) -> Void, onFailure: @escaping (Error?) -> Void) {
    
    connection.add(GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)) { httpResponse, result in
      
      switch result {
        case .success(let response):
          print("Graph Request Succeeded: \(response)")
          onSuccess(response.dictionaryValue)
        
        case .failed(let error):
          print("Graph Request Failed: \(error)")
          onFailure(error)
      }
    }
    
    connection.start()
  }
}

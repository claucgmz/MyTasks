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
  
  func getUserInfo() {
    connection.add(GraphRequest(graphPath: "/me")) { httpResponse, result in
      
      switch result {
      case .success(let response):
        print("Graph Request Succeeded: \(response)")
        
      case .failed(let error):
        print("Graph Request Failed: \(error)")
      }
    }
    
    
    connection.start()
  }
}

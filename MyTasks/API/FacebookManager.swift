//
//  FacebookManager.swift
//  MyTasks
//
//  Created by Claudia Carrillo on 2/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore

class FacebookManager {
  
  func login(_ viewController: UIViewController, onSuccess: @escaping ([String: Any]?) -> Void, onFailure: @escaping (Error?) -> Void) {
    let loginManager = LoginManager()
    
    loginManager.logIn(readPermissions: [.publicProfile], viewController: viewController, completion: {
      loginResult in
      switch loginResult {
      case .failed(let error):
        print(error)
      case .cancelled:
        print("User cancelled login.")
      case .success:
        print("Logged in!")
        self.getUserInfo(onSuccess: onSuccess, onFailure: onFailure)
      }
    })
  }
  
  func logout(user: User) {
    let loginManager = LoginManager()
    loginManager.logOut()
    user.logOut()
  }
  private func getUserInfo(onSuccess: @escaping ([String: Any]?) -> Void, onFailure: @escaping (Error?) -> Void) {
    let connection = GraphRequestConnection()
    
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

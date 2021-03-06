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
  func login(_ viewController: UIViewController, onSuccess: @escaping(String) -> Void, onFailure: @escaping(Error) -> Void) {
    LoginManager().logIn(readPermissions: [.publicProfile, .email], viewController: viewController, completion: { loginResult in
      switch loginResult {
      case .failed(let error):
        onFailure(error)
      case .cancelled:
        print("User cancelled login.")
      case .success(grantedPermissions: _, _, let token):
        onSuccess(token.authenticationToken)
      }
    })
  }
  
  func logout() {
    LoginManager().logOut()
  }
  
  func getUserInfo(onSuccess: @escaping ([String: Any]?) -> Void, onFailure: @escaping (Error) -> Void) {
    let connection = GraphRequestConnection()
    connection.add(GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name"],
      accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)) { _, result in
      switch result {
      case .success(let response):
        onSuccess(response.dictionaryValue)
      case .failed(let error):
        onFailure(error)
      }
    }
    connection.start()
  }
  
  func getToken() -> String? {
    if let token = AccessToken.current?.authenticationToken {
      return token
    }
    return nil
  }
}

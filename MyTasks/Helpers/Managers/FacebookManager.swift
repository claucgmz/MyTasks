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
import Firebase

class FacebookManager {
  func login(_ viewController: UIViewController, onSuccess: @escaping([String: Any]?) -> Void, onFailure: @escaping(Error?) -> Void) {
    LoginManager().logIn(readPermissions: [.publicProfile], viewController: viewController, completion: { loginResult in
      switch loginResult {
      case .failed(let error):
        onFailure(error)
      case .cancelled:
        print("User cancelled login.")
      case .success(grantedPermissions: _, _, let token):
        self.fireBaseLogin(token: token.authenticationToken)
        self.getUserInfo(onSuccess: onSuccess, onFailure: onFailure)
      }
    })
  }
  
  func fireBaseLogin(token: String) {
    let credential = FacebookAuthProvider.credential(withAccessToken: token)
    Auth.auth().signIn(with: credential) { (user, error) in
      if let error = error {
        print(error)
      } else {
        if let user = user {
          DataHelper.save(User(firstName: "", lastName: "", email: "", facebookId: token))
        }

      }
    }
  }
  
  func logout() {
    LoginManager().logOut()
  }
  
  private func getUserInfo(onSuccess: @escaping ([String: Any]?) -> Void, onFailure: @escaping (Error?) -> Void) {
    let connection = GraphRequestConnection()
    connection.add(GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name"], accessToken: AccessToken.current,
                                httpMethod: .GET, apiVersion: .defaultVersion)) { _, result in
      switch result {
      case .success(let response):
        onSuccess(response.dictionaryValue)
      case .failed(let error):
        onFailure(error)
      }
    }
    connection.start()
  }
}

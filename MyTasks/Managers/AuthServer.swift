//
//  AuthServer.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/14/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import Firebase

class AuthServer {
  enum AuthResponse {
    case success
    case failure(String)
  }
  
  static var auth: Auth? {
    return Auth.auth()
  }
  
  static var currentUser: Firebase.User? {
    return auth?.currentUser
  }
  
  static func createAccount(withEmail email: String, password: String) {
    auth?.createUser(withEmail: email, password: password, completion: { user, error in
      
    })
  }
  
  static func login(withEmail email: String, password: String, completion: @escaping (AuthResponse) -> Void) {
    auth?.signIn(withEmail: email, password: password, completion: { user, error in
      
    })
  }
  
  static func login(withFacebook token: String, completion: @escaping (AuthResponse) -> Void) {
    let credential = FacebookAuthProvider.credential(withAccessToken: token)
    auth?.signIn(with: credential, completion: { user, error in
      if let error = error {
        completion(AuthResponse.failure(error.localizedDescription))
      } else if let user = user {
        FacebookManager().getUserInfo(onSuccess: { data in
          let dbUser = User(withFacebook: data)
          dbUser.id = user.uid
          DataHelper.save(dbUser)
          completion(AuthResponse.success)
        }, onFailure: { error in
          completion(AuthResponse.failure(error.localizedDescription))
        })
      }
    })
  }
  
  static func user() -> String? {
    if let user = currentUser {
      return user.uid
    }
    return nil
  }
  
  static func logout(completion: @escaping (AuthResponse) -> Void) {
    guard let auth = auth else {
      completion(.failure("No Authentication"))
      return
    }
    do {
      try auth.signOut()
      completion(.success)
    } catch let signOutError as NSError {
      completion(.failure(signOutError.localizedDescription))
    }
  }
}

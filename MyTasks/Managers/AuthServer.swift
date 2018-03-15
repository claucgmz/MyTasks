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
  
  static func createAccount(withEmail email: String, password: String, completion: @escaping (AuthResponse) -> Void) {
    auth?.createUser(withEmail: email, password: password, completion: { user, error in
      if let user = user, let email = user.email {
        let dbUser = User(id: user.uid, email: email)
        DataHelper.save(dbUser)
        completion(.success)
      } else if let error = error {
        completion(.failure(error.localizedDescription))
      }
    })
  }
  
  static func login(withEmail email: String, password: String, completion: @escaping (AuthResponse) -> Void) {
    auth?.signIn(withEmail: email, password: password, completion: { user, error in
      if user != nil {
        completion(.success)
      } else if let error = error {
        completion(.failure(error.localizedDescription))
      }
    })
  }

  static func login(withFacebook token: String, completion: @escaping (AuthResponse) -> Void) {
    let credential = FacebookAuthProvider.credential(withAccessToken: token)
    auth?.signIn(with: credential, completion: { user, error in
      if let error = error {
        let errorCode = error._code
        switch errorCode {
        case 17012:
          print("Account exists with email")
        default:
          print("sth else")
        }
        completion(.failure(error.localizedDescription))
      } else if let user = user {
        FacebookManager().getUserInfo(onSuccess: { data in
          let dbUser = User(withFacebook: data)
          dbUser.id = user.uid
          DataHelper.save(dbUser)
          completion(.success)
        }, onFailure: { error in
          completion(.failure(error.localizedDescription))
        })
      }
    })
  }
  
  static func linkAccount(withFacebook token: String) {
    let credential = FacebookAuthProvider.credential(withAccessToken: token)
    currentUser?.link(with: credential, completion: { user, error in
      if let user = user {
        print(user.uid)
      }
      
      if let error = error {
        print(error.localizedDescription)
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

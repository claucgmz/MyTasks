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
  
  enum AuthError: Error {
    case emailExistsWithDifferentCredentials
  }
  
  static var isLinkingAccount = false
  
  static var auth: Auth? {
    return Auth.auth()
  }
  
  static var currentUser: Firebase.User? {
    return auth?.currentUser
  }
  
  static func activateListener(completion: @escaping () -> Void) {
    auth?.addStateDidChangeListener { _, user in
      if let user = user {
        debugPrint(user)
        completion()
      }
    }
  }
  static func getProviderId(for provider: String) -> String? {
    guard let providerData = currentUser?.providerData else {
      return nil
    }
    for providerInfo in providerData where providerInfo.providerID == "facebook.com" {
     return providerInfo.uid
    }
    
    return nil
  }
  
  static func createAccount(withEmail email: String, password: String, completion: @escaping (AuthResponse) -> Void) {
    auth?.createUser(withEmail: email, password: password) { user, error in
      if let user = user, let email = user.email {
        debugPrint(user)
        debugPrint(user.providerData)
        let dbUser = User(id: user.uid, email: email)
        DataHelper.save(dbUser)
        completion(.success)
      } else if let error = error {
        completion(.failure(error.localizedDescription))
      }
    }
  }
  
  static func login(withEmail email: String, password: String, completion: @escaping (AuthResponse) -> Void) {
    auth?.signIn(withEmail: email, password: password) { user, error in
      if let error = error {
        completion(.failure(error.localizedDescription))
      }
    }
  }

  static func login(withFacebook token: String, completion: @escaping (AuthResponse) -> Void, completionLink: @escaping (String) -> Void) {
    let credential = FacebookAuthProvider.credential(withAccessToken: token)
    auth?.signIn(with: credential) { user, error in
      if let error = error {
        let errorCode = error._code
        switch errorCode {
        case 17012:
          if let email = (error as NSError).userInfo ["FIRAuthErrorUserInfoEmailKey"] as? String {
            completionLink(email)
          }
          
        default:
          print("Nothing to do.")
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
    }
  }
  
  static func linkAccount(withFacebook token: String, completion: @escaping (AuthResponse) -> Void) {
    let credential = FacebookAuthProvider.credential(withAccessToken: token)
    currentUser?.link(with: credential, completion: { user, error in
      if let user = user {
        print(user.uid)
        isLinkingAccount = false
        completion(.success)
      }
      
      if let error = error {
        completion(.failure(error.localizedDescription))
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
  
  private static func addToRepository() {
    
  }
}

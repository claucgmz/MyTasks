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
  
  static var isLinkingAccount = false
  static var authListener: AuthStateDidChangeListenerHandle?
  static var auth: Auth? {
    return Auth.auth()
  }
  
  static var currentUser: Firebase.User? {
    return auth?.currentUser
  }
  
  static func activateListener(completion: @escaping () -> Void) {
    authListener = auth?.addStateDidChangeListener { _, user in
      if let user = user {
        debugPrint(user)
        completion()
      }
    }
  }
  
  static func removeListener() {
    guard let authListener = authListener else {
      return
    }
    auth?.removeStateDidChangeListener(authListener)
  }
  
  static func getProviderId(for provider: String) -> String? {
    guard let providerData = currentUser?.providerData else {
      return nil
    }
    for providerInfo in providerData where providerInfo.providerID == provider {
      return providerInfo.uid
    }
    
    return nil
  }
  
  static func createAccount(withEmail email: String, password: String, completion: @escaping (AuthResponse) -> Void) {
    auth?.createUser(withEmail: email, password: password) { user, error in
      if user != nil {
        completion(.success)
      } else if let error = error {
        completion(.failure(error.localizedDescription))
      }
    }
  }
  
  static func login(withEmail email: String, password: String, completion: @escaping (AuthResponse) -> Void) {
    auth?.signIn(withEmail: email, password: password) { _, error in
      if let error = error {
        completion(.failure(error.localizedDescription))
      }
    }
  }
  
  static func login(withFacebook token: String, completion: @escaping (AuthResponse) -> Void, completionLink: @escaping (String) -> Void) {
    let credential = FacebookAuthProvider.credential(withAccessToken: token)
    auth?.signIn(with: credential) { _, error in
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
      } else {
        FacebookManager().getUserInfo(onSuccess: { userData in
          if let userData = userData {
            updateProfileData(with: userData)
          }
        }, onFailure: { error in print(error) })
        completion(.success)
      }
    }
  }
  
  static func linkAccount(withFacebook token: String, completion: @escaping (AuthResponse) -> Void) {
    let credential = FacebookAuthProvider.credential(withAccessToken: token)
    currentUser?.link(with: credential) { user, error in
      if user != nil {
        isLinkingAccount = false
        completion(.success)
      }
      
      if let error = error {
        completion(.failure(error.localizedDescription))
        print(error.localizedDescription)
      }
    }
  }
  
  static func updateProfileData(with facebookData: [String: Any?]) {
    guard let user = currentUser else {
      return
    }
    
    let changeRequest = user.createProfileChangeRequest()

    if let firstName = facebookData["first_name"] as? String, let lastName = facebookData["last_name"] as? String {
      changeRequest.displayName = "\(firstName) \(lastName)"
    }
    
    changeRequest.commitChanges(completion: nil)
  }
  
  static func userId() -> String? {
    if let user = currentUser {
      return user.uid
    }
    return nil
  }
  
  static func user() -> User {
   let facebookId = getProviderId(for: "facebook.com")
    return User(id: userId()!, email: currentUser?.email ?? "", displayName: currentUser?.displayName ?? "Stranger", facebookId: facebookId ?? "")
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

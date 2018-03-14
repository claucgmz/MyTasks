//
//  UserManager.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/27/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//
import UIKit
import Firebase

class UserManager {
  func loginWithFacebook(viewController: UIViewController, onSuccess: @escaping() -> Void, onFailure: @escaping(Error?) -> Void) {
    FacebookManager().login(viewController, onSuccess: { token, data in
      self.loginWithFirebase(token: token, userData: data, onSuccess: {
        FacebookManager().logout()
        onSuccess()
      }, onFailure: { error in print("Error: \(String(describing: error?.localizedDescription))") })
    }, onFailure: { error in
      print("Error: \(String(describing: error?.localizedDescription))")
    })
  }
  
  func logout() {
    DataHelper.logOut()
  }
  
  func loginWithFirebase(token: String, userData: [String: Any]?, onSuccess: @escaping() -> Void, onFailure: @escaping(Error?) -> Void) {
    let credential = FacebookAuthProvider.credential(withAccessToken: token)
    Auth.auth().signIn(with: credential) { (user, error) in
      if let error = error {
        print(error)
      } else {
        if let user = user {
          let dbUser = User(with: userData)
          dbUser.id = user.uid
          DataHelper.save(dbUser)
          onSuccess()
        }
      }
      
    }
  }
}

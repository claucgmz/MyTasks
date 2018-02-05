//
//  LoginViewController.swift
//  MyTasks
//
//  Created by Claudia Carrillo on 2/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import RealmSwift

class LoginViewController: UIViewController {
  var users : Results<User>!
  let realm = RealmService.shared.realm
  
  override func viewDidLoad() {
    super.viewDidLoad()

    users = realm.objects(User.self)
    
    print(users)
    
    if let FBaccessToken = AccessToken.current {
      
    }
    else {
      addFBLoginButton()
    }
    
  }
  
  // MARK: -  Private methods
  
  private func addFBLoginButton() {
    let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
    loginButton.center = view.center
    loginButton.delegate = self
    view.addSubview(loginButton)
  }

}

// MARK: -  Logun Button Delegate methods
extension LoginViewController: LoginButtonDelegate {
  func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
    print("user logged in")
    let facebookManager = FacebookManager()
    facebookManager.getUserInfo(onSuccess: { data in
      let user = User(with: data)
      print(user)
      
      if let exist = self.realm.object(ofType: User.self, forPrimaryKey: user.id) {
        print("User exists")
      }
      else {
        RealmService.shared.create(user)
        print("create the new user")
      }
      
    }, onFailure: { error in
      
        print(error)
    })
  }
  
  func loginButtonDidLogOut(_ loginButton: LoginButton) {
    print("user logged out")
  }
}

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

class LoginViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    facebookManager.getUserInfo()
  }
  
  func loginButtonDidLogOut(_ loginButton: LoginButton) {
    print("user logged out")
  }
}

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
  private let realm = RealmService.shared.realm
  private var user: User?

  @IBOutlet private weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addFBLoginButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if User.getLoggedUser() != nil {
      goToHome()
    }
  }
  
  // MARK: -  Private methods
  private func addFBLoginButton() {
    let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
    loginButton.center = view.center
    loginButton.delegate = self
    view.addSubview(loginButton)
  }
  
  private func goToHome() {
    self.performSegue(withIdentifier: "HomeSegue", sender: self)
  }
}

// MARK: -  Logun Button Delegate methods
extension LoginViewController: LoginButtonDelegate {
  func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
    
    let facebookManager = FacebookManager()
    facebookManager.getUserInfo(onSuccess: { data in
      var user = User(with: data)
      if let exists = user.exists() {
        user = exists
      } else {
        user.add()
      }
      
      user.logIn()

      DispatchQueue.main.async {
        self.goToHome()
      }
      
    }, onFailure: { error in
      if error != nil {
        print("Error: \(String(describing: error?.localizedDescription))")
      }
    })
  }
  
  func loginButtonDidLogOut(_ loginButton: LoginButton) {
    user?.logOut()
  }
}

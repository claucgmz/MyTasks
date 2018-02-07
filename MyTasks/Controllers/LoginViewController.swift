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
  let realm = RealmService.shared.realm
  var user: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addFBLoginButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if isLoggedIn() {
      user = realm.object(ofType: User.self, forPrimaryKey: UserDefaults.standard.getUserId())
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
  
  private func isLoggedIn() -> Bool {
    return UserDefaults.standard.isLoggedIn()
  }
  
  private func goToHome() {
    self.performSegue(withIdentifier: "HomeSegue", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "HomeSegue" {
      let controller = segue.destination as! MainViewController
      controller.user = user
    }
  }
  
}

// MARK: -  Logun Button Delegate methods
extension LoginViewController: LoginButtonDelegate {
  func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
    let facebookManager = FacebookManager()
    facebookManager.getUserInfo(onSuccess: { data in
      
      let currentUser = User(with: data)
      if let exist = self.realm.object(ofType: User.self, forPrimaryKey: currentUser.id) {
        self.user = exist
        UserDefaults.standard.setUserId(with: exist.id)
      }
      else {
        RealmService.shared.create(currentUser)
        self.user = currentUser
        UserDefaults.standard.setUserId(with: currentUser.id)
      }
      
      UserDefaults.standard.setIsLoggedIn(value: true)
      
      DispatchQueue.main.async {
        self.goToHome()
      }

    }, onFailure: { error in
      if error != nil {
        print("Erro: \(String(describing: error?.localizedDescription))")
      }
    })
  }
  
  func loginButtonDidLogOut(_ loginButton: LoginButton) {
    UserDefaults.standard.setIsLoggedIn(value: false)
  }
}

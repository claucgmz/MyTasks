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
  var users: Results<User>!
  let realm = RealmService.shared.realm
  var user: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    users = realm.objects(User.self)
    
    print(users)
    
    addFBLoginButton()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if isLoggedIn() {
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
      print("the user")
      print(user)
      let controller = segue.destination as! MainViewController
      controller.user = user
    }
  }
  
}

// MARK: -  Logun Button Delegate methods
extension LoginViewController: LoginButtonDelegate {
  func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
    print("user logged in")
    let facebookManager = FacebookManager()
    facebookManager.getUserInfo(onSuccess: { data in
      let currentUser = User(with: data)
      print(currentUser)
      
      if let exist = self.realm.object(ofType: User.self, forPrimaryKey: currentUser.id) {
        print("User exists")
        self.user = exist
        UserDefaults.standard.setUserId(with: exist.id)
      }
      else {
        RealmService.shared.create(currentUser)
        print("create the new user")
        self.user = currentUser
        UserDefaults.standard.setUserId(with: currentUser.id)
      }
      
      UserDefaults.standard.setIsLoggedIn(value: true)
      
      DispatchQueue.main.async {
        self.goToHome()
      }
      
      
    }, onFailure: { error in
      
      print(error)
    })
  }
  
  func loginButtonDidLogOut(_ loginButton: LoginButton) {
    UserDefaults.standard.setIsLoggedIn(value: false)
    print("user logged out")
  }
}

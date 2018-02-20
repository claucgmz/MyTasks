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
    loginButton.setTitle(NSLocalizedString("log_in", comment: ""), for: .normal)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if User.getLoggedUser() != nil {
      goToHome()
    }
  }
  
  // MARK: -  Private methods
  
  private func goToHome() {
    self.performSegue(withIdentifier: "HomeSegue", sender: self)
  }
  
  @IBAction func loginButtonAction(_ sender: Any) {
    let loginManager = LoginManager()
    loginManager.logIn(readPermissions: [.publicProfile], viewController: self, completion: {
      loginResult in
      switch loginResult {
      case .failed(let error):
        print(error)
      case .cancelled:
        print("User cancelled login.")
      case .success:
        print("Logged in!")
        self.loginUser()
      }
    })
  }
  
  private func loginUser() {
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
}

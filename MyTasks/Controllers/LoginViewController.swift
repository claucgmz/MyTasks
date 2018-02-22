//
//  LoginViewController.swift
//  MyTasks
//
//  Created by Claudia Carrillo on 2/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
  private let realm = RealmService.realm
  private let facebookManager = FacebookManager()
  
  @IBOutlet private weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateButtonUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if User.getLoggedUser() != nil {
      goToHome()
    }
  }
  
  // MARK: - Action methods
  @IBAction private func loginButtonAction(_ sender: Any) {
    facebookManager.login(self, onSuccess: { data in
      let user = User(with: data)
      user.add()
      
      DispatchQueue.main.async {
        self.goToHome()
      }
      
    }, onFailure: { error in
      if error != nil {
        print("Error: \(String(describing: error?.localizedDescription))")
      }
    })
  }
  
  // MARK: -  Private methods
  private func goToHome() {
    self.performSegue(withIdentifier: "HomeSegue", sender: self)
  }
  
  private func updateButtonUI() {
    loginButton.setTitle(NSLocalizedString("log_in", comment: ""), for: .normal)
    loginButton.imageView?.contentMode = .scaleAspectFit
    loginButton.imageEdgeInsets = UIEdgeInsetsMake(6.0, 0.0, 6.0, 5.0)
    loginButton.roundCorners(withRadius: 5.0)
  }
}

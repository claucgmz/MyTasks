//
//  LoginVC.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/16/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var loginButton: UIButton!
  @IBOutlet private weak var cancelButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setLocalize()
  }
  
  private func setLocalize() {
    loginButton.setTitle("log_in".localized, for: .normal)
    cancelButton.setTitle("cancel".localized, for: .normal)
    emailTextField.placeholder = "email".localized
    passwordTextField.placeholder = "password".localized
  }
  
  @IBAction private func loginAccountAction(_ sender: Any) {
    guard let email = emailTextField.text, let password = passwordTextField.text else {
      return
    }
    AuthServer.login(withEmail: email, password: password, completion: { authResponse in
      guard case .failure(let message) = authResponse else {
        return
      }
      self.showSnackbar(with: message)
    })
  }
  
  @IBAction private func cancelButton(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

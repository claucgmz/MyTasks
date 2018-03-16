//
//  LoginViewController.swift
//  MyTasks
//
//  Created by Claudia Carrillo on 2/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var errorLabel: UILabel!
  @IBOutlet weak var orLabel: UILabel!
  @IBOutlet private weak var loginButton: UIButton!
  @IBOutlet private weak var createButton: UIButton!
  @IBOutlet private weak var loginFacebookButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  // MARK: - private methods
  private func updateUI() {
    errorLabel.text = ""
    orLabel.text = "or".localized
    emailTextField.placeholder = "email".localized
    passwordTextField.placeholder = "password".localized
    loginButton.didEnable(false)
    createButton.didEnable(false)
    createButton.setTitle("create_account".localized, for: .normal)
    loginButton.setTitle("log_in".localized, for: .normal)
    loginFacebookButton.setTitle("log_in".localized, for: .normal)
    loginFacebookButton.imageView?.contentMode = .scaleAspectFit
  }
  
  private func segueToHome() {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    appDelegate?.window?.rootViewController = UIStoryboard(name: "MyTasks", bundle: nil)
      .instantiateViewController(withIdentifier: SliderMenuViewController.reusableId)
  }
  
  private func enableButtons() -> Bool {
    guard let email = emailTextField.text, let password = passwordTextField.text else {
      return false
    }
    
    if email.isEmpty || !email.isEmail {
      return false
    }
    
    if password.isEmpty {
      return false
    }
    
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    emailTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
  }
  
  // MARK: - Action methods
  @IBAction private func loginButtonAction(_ sender: Any) {
    errorLabel.text = ""
    guard let email = emailTextField.text, let password = passwordTextField.text else {
      return
    }
    AuthServer.login(withEmail: email, password: password, completion: { authResponse in
      switch authResponse {
      case .success:
        self.segueToHome()
      case let .failure(message):
        self.errorLabel.text = message
      }
    })
  }
  
  @IBAction private func createAccountButtonAction(_ sender: Any) {
    errorLabel.text = ""
    guard let email = emailTextField.text, let password = passwordTextField.text else {
      return
    }
    AuthServer.createAccount(withEmail: email, password: password, completion: { authResponse in
      switch authResponse {
      case .success:
        self.segueToHome()
      case let .failure(message):
        self.errorLabel.text = message
      }
    })
    
  }
  
  @IBAction private func loginFacebookButtonAction(_ sender: Any) {
    errorLabel.text = ""
    FacebookManager().login(self, onSuccess: { token in
      AuthServer.login(withFacebook: token, completion: { authResponse in
        switch authResponse {
        case .success:
          FacebookManager().logout()
          self.segueToHome()
        case let .failure(message):
          self.errorLabel.text = message
        }
      }, completionLink: { email in
        print(email)
      })
    }, onFailure: { error in
      self.errorLabel.text = error.localizedDescription
    })
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    errorLabel.text = ""
    let enable = enableButtons()
    loginButton.didEnable(enable)
    createButton.didEnable(enable)
    return true
  }
}

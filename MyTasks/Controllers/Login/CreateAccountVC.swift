//
//  CreateAccountVC.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/15/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var createButton: UIButton!
  @IBOutlet private weak var cancelButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    setLocalize()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    hideKeyboard()
  }
  private func setLocalize() {
    titleLabel.text = "create_account".localized
    createButton.setTitle("create_account".localized, for: .normal)
    cancelButton.setTitle("cancel".localized, for: .normal)
    emailTextField.placeholder = "email".localized
    passwordTextField.placeholder = "password".localized
  }
  private func hideKeyboard() {
    emailTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
  }
  @IBAction private func createAccountAction(_ sender: Any) {
    guard let email = emailTextField.text, let password = passwordTextField.text else {
      return
    }
    AuthServer.createAccount(withEmail: email, password: password, completion: { authResponse in
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

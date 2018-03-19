//
//  LinkAccountVC.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/15/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class LinkAccountVC: UIViewController {
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var linkButton: UIButton!
  @IBOutlet private weak var cancelButton: UIButton!
  var email = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    AuthServer.activateListener {
      self.segueToHome()
    }
    emailTextField.text = email
    setLocalize()
  }
  
  deinit {
    AuthServer.removeListener()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  private func setLocalize() {
    //linkButton.setTitle("link_account".localized, for: .normal)
    cancelButton.setTitle("cancel".localized, for: .normal)
    emailTextField.placeholder = "email".localized
    passwordTextField.placeholder = "password".localized
  }
  
  private func hideKeyboard() {
    emailTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
  }
  
  private func segueToHome() {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    appDelegate?.window?.rootViewController = UIStoryboard(name: "MyTasks", bundle: nil)
      .instantiateViewController(withIdentifier: SliderMenuViewController.reusableId)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    hideKeyboard()
  }
  
  @IBAction func linkButtonAction(_ sender: Any) {
    guard let email = emailTextField.text, let password = passwordTextField.text else {
      return
    }
    AuthServer.isLinkingAccount = true
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

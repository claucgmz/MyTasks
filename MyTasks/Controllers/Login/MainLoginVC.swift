//
//  MainLoginVC.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 3/15/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class MainLoginVC: UIViewController {
  @IBOutlet private weak var facebookLoginButton: UIButton!
  @IBOutlet private weak var createAccountButton: UIButton!
  @IBOutlet private weak var loginButton: UIButton!
  private var email = ""
  private var wasLinked = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setLocalize()
    AuthServer.activateListener {
      if AuthServer.isLinkingAccount {
        self.linkAccount()
      } else {
        self.view.endEditing(true)
        self.segueToHome()
      }
    }
  }
  
  deinit {
    AuthServer.removeListener()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  private func setLocalize() {
    createAccountButton.setTitle("create_account".localized, for: .normal)
    loginButton.setTitle("log_in".localized, for: .normal)
    facebookLoginButton.setTitle("log_in".localized, for: .normal)
    facebookLoginButton.imageView?.contentMode = .scaleAspectFit
  }
  
  private func segueToHome() {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    appDelegate?.window?.rootViewController = UIStoryboard(name: "MyTasks", bundle: nil)
      .instantiateViewController(withIdentifier: SliderMenuViewController.reusableId)
  }
  
  private func linkAccount() {
    if let token = FacebookManager().getToken() {
      AuthServer.linkAccount(withFacebook: token, completion: { authResponse in
        switch authResponse {
        case .success:
          self.wasLinked = true
          self.segueToHome()
        case .failure(let message):
          self.showSnackbar(with: message)
        }
      })
      
    }
  }
  
  private func segueToLink() {
    performSegue(withIdentifier: SegueIdentifier.linkAccount.rawValue, sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    switch identifier {
    case SegueIdentifier.linkAccount.rawValue:
      guard let controller = segue.destination as? LinkAccountVC else {
        return
      }
      controller.email = email
    default:
      guard let controller = segue.destination as? HomeViewController else {
        return
      }
      if wasLinked {
        controller.successMessage = "link_account_success_message".localized
      }
    }
  }
  
  @IBAction private func facebookLoginAction(_ sender: Any) {
    FacebookManager().login(self, onSuccess: { token in
      AuthServer.login(withFacebook: token, completion: { authResponse in
        guard case .failure(let message) = authResponse else {
          return
        }
        self.showSnackbar(with: message)
      }, completionLink: { email in
        self.email = email
        self.segueToLink()
      })
    }, onFailure: { error in
      self.showSnackbar(with: error.localizedDescription)
    })
  }
}

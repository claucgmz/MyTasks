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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setLocalize()
    AuthServer.activateListener {
      if AuthServer.isLinkingAccount {
        self.linkAccount()
      } else {
        self.segueToHome()
      }
    }
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
          self.segueToHome()
        case .failure(let message):
          print(message)
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
    if identifier == SegueIdentifier.linkAccount.rawValue {
      guard let controller = segue.destination as? LinkAccountVC else {
        return
      }
      controller.email = email
    }
  }
  
  @IBAction private func facebookLoginAction(_ sender: Any) {
    FacebookManager().login(self, onSuccess: { token in
      AuthServer.login(withFacebook: token, completion: { authResponse in
        guard case .failure(let message) = authResponse else {
          return
        }
        print(message)
      }, completionLink: { email in
        self.email = email
        self.segueToLink()
      })
    }, onFailure: { error in
      print(error.localizedDescription)
    })
  }
}

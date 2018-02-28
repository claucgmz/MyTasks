//
//  LoginViewController.swift
//  MyTasks
//
//  Created by Claudia Carrillo on 2/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  @IBOutlet private weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loginButton.setTitle("log_in".localized, for: .normal)
    loginButton.imageView?.contentMode = .scaleAspectFit
  }
  
  // MARK: - private methods
  private func segueToHome() {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    appDelegate?.window?.rootViewController = UIStoryboard(name: "MyTasks", bundle: nil).instantiateViewController(withIdentifier:SliderMenuViewController.reusableId)
  }

  // MARK: - Action methods
  @IBAction private func loginButtonAction(_ sender: Any) {
    
    UserManager().loginWithFacebook(viewController: self, onSuccess: { DispatchQueue.main.async { self.segueToHome() } },
                                    onFailure: { error in print(error?.localizedDescription ?? "Something went wrong") })
  }
}

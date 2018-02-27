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
    updateButtonUI()
  }
  
  // MARK: - private methods
  private func segueToHome() {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    appDelegate?.window?.rootViewController = UIStoryboard(name: "MyTasks", bundle: nil).instantiateViewController(withIdentifier:SliderMenuViewController.reusableId)
  }
  
  private func updateButtonUI() {
    loginButton.setTitle("log_in".localized, for: .normal)
    loginButton.imageView?.contentMode = .scaleAspectFit
  }
  
  // MARK: - Action methods
  @IBAction private func loginButtonAction(_ sender: Any) {
    //DispatchQueue.main.async {
    UserManager().loginWithFacebook(viewController: self, onSuccess: { self.segueToHome() }, onFailure: { error in print(error?.localizedDescription ?? "Something went wrong") })
  }
}

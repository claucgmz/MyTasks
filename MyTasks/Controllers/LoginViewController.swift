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
    print(Realm.Configuration.defaultConfiguration.fileURL!)
    updateButtonUI()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
  private func goToHome() {
    let initialViewController = UIStoryboard(name: "MyTasks", bundle:nil).instantiateViewController(withIdentifier: "MyTasks") as! SliderMenuViewController
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    appDelegate.window?.rootViewController = initialViewController
  }
  private func updateButtonUI() {
    loginButton.setTitle(NSLocalizedString("log_in", comment: ""), for: .normal)
    loginButton.imageView?.contentMode = .scaleAspectFit
  }
}

//
//  MenuViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/19/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import AlamofireImage

class MenuViewController: UIViewController {
  private let facebookManager = FacebookManager()
  @IBOutlet weak var userProfileImage: UIImageView!
  @IBOutlet private weak var logoutButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    logoutButton.setTitle(NSLocalizedString("log_out", comment: ""), for: .normal)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  @IBAction private func logOut(_ sender: Any) {
    if let user = RealmService.getLoggedUser() {
      facebookManager.logout(user: user)
    }
    slideMenuController()?.closeLeft()
    navigationController?.popViewController(animated: true)
  }
}

//
//  MenuViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/19/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  @IBOutlet weak var userProfileImage: UIImageView!
  @IBOutlet private weak var logoutButton: UIButton!
  @IBOutlet weak var userName: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    logoutButton.setTitle("log_out".localized, for: .normal)
  }
  @IBAction private func logOut(_ sender: Any) {
    AuthServer.logout(completion: { _ in
      self.slideMenuController()?.closeLeft()
    })
  }
}

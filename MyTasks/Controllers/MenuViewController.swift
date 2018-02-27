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
    logoutButton.setTitle("log_out".localized, for: .normal)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  @IBAction private func logOut(_ sender: Any) {
    UserManager().logoutWithFacebook()
    slideMenuController()?.closeLeft()
    navigationController?.popViewController(animated: true)
  }
}

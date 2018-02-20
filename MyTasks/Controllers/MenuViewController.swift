//
//  MenuViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/19/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import AlamofireImage

class MenuViewController: UIViewController {
  var user: User?
  
  @IBOutlet weak var userProfileImage: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    user = User.getLoggedUser()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  @IBAction private func logOut(_ sender: Any) {
    let loginManager = LoginManager()
    loginManager.logOut()
    user?.logOut()
    slideMenuController()?.closeLeft()
    navigationController?.popViewController(animated: true)
  }
}

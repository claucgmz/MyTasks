//
//  AppDelegate.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/5/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let navigationBarAppearance = UINavigationBar.appearance()
    navigationBarAppearance.isTranslucent = true
    navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
    navigationBarAppearance.shadowImage = UIImage()
    setInitialViewController()
    return true
  }
  
  private func setInitialViewController() {
    var initialViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: LoginViewController.reusableId)
    if RealmService.getLoggedUser() != nil {
      initialViewController = UIStoryboard(name: "MyTasks", bundle: nil).instantiateViewController(withIdentifier: SliderMenuViewController.reusableId)
    }
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = initialViewController
    self.window?.makeKeyAndVisible()
  }

}


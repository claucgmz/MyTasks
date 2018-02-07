//
//  MainViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
  
  @IBOutlet private weak var userProfileImage: UIImageView!
  @IBOutlet private weak var welcomeLabel: UILabel!
  @IBOutlet private weak var todaySummaryLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  
  var lists = ["List 1" , "List 2", "List 3",  "List 2", "List 3"]
  var listCollectionCellId = "ListCell"
  let realm = RealmService.shared.realm
  
  var user: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getUser()
    updateView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  private func getUser() {
    print("id")
    print(UserDefaults.standard.getUserId())
    user = realm.object(ofType: User.self, forPrimaryKey: UserDefaults.standard.getUserId())
    print(user)
  }
  
  private func updateView() {
    setUserProfileImage()
    if let firstName = user?.firstName {
       welcomeLabel.text = String.init(format: NSLocalizedString("Hello, %@", comment: ""), arguments: [firstName])
    }
    
    let date = Date()
    let locale = Locale.current
    
    if let region = locale.regionCode {
      let dateString = date.toString(withLocale: region)
      dateLabel.text = "\(NSLocalizedString("Today", comment: "")): \(dateString)".uppercased()
    }

    //todaySummaryLabel.text = String.init(format: NSLocalizedString("You have %@ tasks to do today", comment: ""), arguments: [3])
  }
  
  private func setUserProfileImage() {
    guard let imageURL = URL(string: "https://graph.facebook.com/10156546140303465/picture?type=large") else {
      return
    }
    UserManager.shared.getImageFromURL(request: imageURL, onSuccess: { data in
      
      guard let data = data else {
        return
      }
      
      self.userProfileImage.image = UIImage(data: data)
      
    }, onFailure: { error in
      print(error)
    })
    
    userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width / 2
    userProfileImage.clipsToBounds = true
    userProfileImage.layer.shadowColor = UIColor.black.cgColor
    userProfileImage.layer.shadowOpacity = 1
    userProfileImage.layer.shadowOffset = CGSize.zero
    userProfileImage.layer.shadowRadius = 10
    userProfileImage.layer.shadowPath = UIBezierPath(rect: userProfileImage.bounds).cgPath
    userProfileImage.layer.shouldRasterize = true
  }
  
}

extension MainViewController: UICollectionViewDelegate {
  
}

extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return lists.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCollectionCellId, for: indexPath)
    
    return cell
  }
}

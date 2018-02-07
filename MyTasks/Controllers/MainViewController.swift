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
  
  @IBOutlet private weak var taskListCollectionView: UICollectionView!
  @IBOutlet private weak var userProfileImage: UIImageView!
  @IBOutlet private weak var welcomeLabel: UILabel!
  @IBOutlet private weak var todaySummaryLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  
  var lists = [TaskList]()
  let taskItemCellId = "taskListCell"
  let addTaskItemCellId = "addTaskListCell"
  let realm = RealmService.shared.realm
  var user: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getUser()
    updateView()
    registerNibs()
    
    let list1 = TaskList(name: "My new Task List 1")
    lists.append(list1)
    let list2 = TaskList(name: "My new Task List 2")
    lists.append(list2)
    let list3 = TaskList(name: "My new Task List 3")
    lists.append(list3)
    let list4 = TaskList(name: "My new Task List 4")
    lists.append(list4)
    let list5 = TaskList(name: "My new Task List 5")
    lists.append(list5)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  private func registerNibs() {
    let taskItemCellNib = UINib(nibName: "TaskListCollectionCell", bundle: nil)
    taskListCollectionView.register(taskItemCellNib, forCellWithReuseIdentifier: taskItemCellId)
    
    let addTaskItemCellNib = UINib(nibName: "AddTaskListCollectionCell", bundle: nil)
    taskListCollectionView.register(addTaskItemCellNib, forCellWithReuseIdentifier: addTaskItemCellId)
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
    return lists.count + 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.row < lists.count {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskItemCellId, for: indexPath) as! TaskListCollectionCell
      
      let taskList = lists[indexPath.row]
      cell.configure(withTaskList: taskList)
      
      return cell
    }
    else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addTaskItemCellId, for: indexPath) as! AddTaskListCollectionCell
      return cell
    }
  }
}

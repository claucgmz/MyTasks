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
  let realm = RealmService.shared.realm
  var user: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    taskListCollectionView.register(taskItemCellNib, forCellWithReuseIdentifier: TaskListCollectionCell.reusableId)

    let addTaskItemCellNib = UINib(nibName: "AddTaskListCollectionCell", bundle: nil)
    taskListCollectionView.register(addTaskItemCellNib, forCellWithReuseIdentifier: AddTaskListCollectionCell.reusableId)
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
    
    if let imageUrl = user?.imageURL {
      print(imageUrl)
      guard let imageURL = URL(string: imageUrl) else {
        return
      }
      
      print(imageURL)
      
      UserManager.shared.getImage(fromUrl: imageURL, onSuccess: { data in
        print(data)
        guard let data = data else {
          return
        }
        DispatchQueue.main.async {
          self.userProfileImage.image = UIImage(data: data)
        }
        
      }, onFailure: { error in
        
        if error != nil {
          //print(error?.localizedDescription)
        }
      })
      
      //userProfileImage.dropShadow(color: .darkGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
      userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width / 2
      userProfileImage.clipsToBounds = true
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddTaskList" {
      let controller = segue.destination as! AddTaskListViewController
      controller.delegate = self
    }
  }
  
}

extension MainViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row < lists.count {
      
    }
    else {
      performSegue(withIdentifier: "AddTaskList", sender: self)
    }
  }
}

extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return lists.count + 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.row < lists.count {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskListCollectionCell.reusableId, for: indexPath) as! TaskListCollectionCell
      cell.roundCorners(withRadius: 10)
      let taskList = lists[indexPath.row]
      cell.configure(withTaskList: taskList)
      
      return cell
    }
    else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddTaskListCollectionCell.reusableId, for: indexPath) as! AddTaskListCollectionCell
      cell.roundCorners(withRadius: 10)
      return cell
    }
  }
  
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: collectionView.frame.width*0.8, height: collectionView.frame.height)
  }
}

extension MainViewController: AddTaskListViewControllerDelegate {
  func addTaskListTableViewController(_ controller: AddTaskListViewController, didFinishAdding tasklist: TaskList) {
    lists.append(tasklist)
    taskListCollectionView.reloadData()
    navigationController?.popViewController(animated:true)
  }
}

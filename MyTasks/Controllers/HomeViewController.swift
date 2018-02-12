//
//  HomeViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
  
  @IBOutlet private weak var taskListCollectionView: UICollectionView!
  @IBOutlet private weak var userProfileImage: UIImageView!
  @IBOutlet private weak var welcomeLabel: UILabel!
  @IBOutlet private weak var todaySummaryLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  
  var tasklists : Results<TaskList>!
  var user: User!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let realm = RealmService.shared.realm
    user = User.getLoggedUser()
    tasklists = realm.objects(TaskList.self)
    updateView()
    registerNibs()
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
  
  @objc private func showMoreActionSheet(_ sender: UIButton) {
    let index = sender.tag
    let alert = UIAlertController(title: "What do you want to do?", message: "", preferredStyle: .actionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let editAction = UIAlertAction(title: "Edit", style: .default, handler: { action in
      let tasklist = self.tasklists[index]
      self.performSegue(withIdentifier: "TaskListDetail", sender: tasklist)
    })
    
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
    
    alert.addAction(cancelAction)
    alert.addAction(editAction)
    alert.addAction(deleteAction)
    
    self.present(alert, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TaskListDetail" {
      let controller = segue.destination as! TaskListDetailViewController
      controller.delegate = self
      
      if sender is TaskList {
        controller.tasklistToEdit = sender as? TaskList
      }
    }
  }
  
}

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row < tasklists.count {
      let tasklist = tasklists[indexPath.row]
      performSegue(withIdentifier: "TaskListDetail", sender: tasklist)
    } else {
      performSegue(withIdentifier: "TaskListDetail", sender: self)
    }
  }
}

extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tasklists.count + 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.row < tasklists.count {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskListCollectionCell.reusableId, for: indexPath) as! TaskListCollectionCell
      cell.roundCorners(withRadius: 10)
      let taskList = tasklists[indexPath.row]
      cell.configure(with: taskList, index: indexPath.row)
      cell.moreButton.addTarget(self, action: #selector(showMoreActionSheet(_:)), for: .touchUpInside)
      
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddTaskListCollectionCell.reusableId, for: indexPath) as! AddTaskListCollectionCell
      cell.roundCorners(withRadius: 10)
      return cell
    }
  }
  
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: collectionView.frame.width*0.8, height: collectionView.frame.height)
  }
}

extension HomeViewController: TaskListDetailViewControllerDelegate {
  func taskListDetailViewController(_ controller: TaskListDetailViewController, didFinishAdding tasklist: TaskList) {
    taskListCollectionView.reloadData()
    navigationController?.popViewController(animated:true)
  }
  
  func taskListDetailViewController(_ controller: TaskListDetailViewController, didFinishEditing tasklist: TaskList) {
    taskListCollectionView.reloadData()
    navigationController?.popViewController(animated:true)
  }
}

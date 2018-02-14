//
//  HomeViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage

class HomeViewController: UIViewController {
  
  @IBOutlet private weak var taskListCollectionView: UICollectionView!
  @IBOutlet private weak var userProfileImage: UIImageView!
  @IBOutlet private weak var welcomeLabel: UILabel!
  @IBOutlet private weak var todaySummaryLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  
  var tasklists : Results<TaskList>!
  var user: User!
  let imageDownloader = ImageDownloader()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let realm = RealmService.shared.realm
    user = User.getLoggedUser()
    tasklists = realm.objects(TaskList.self)
    setViewWithData()
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
  
  private func reloadTasks() {
    taskListCollectionView.reloadData()
    navigationController?.popViewController(animated:true)
  }
  
  private func setProfileImage() {
    if let url = user?.imageURL {
      let imageCache = AutoPurgingImageCache()

      guard let cachedAvatarImage = imageCache.image(withIdentifier: "avatar") else {
        downloadImage(from: url, completionHandler: { image, urlRequest in
          let avatarImage = image.af_imageRoundedIntoCircle()
          imageCache.add(avatarImage, for: urlRequest, withIdentifier: "avatar")
          self.userProfileImage.image = avatarImage
        })
        return
      }
      
      userProfileImage.image = cachedAvatarImage
    }
  }
  
  private func downloadImage(from url: String, completionHandler: @escaping(Image, URLRequest) -> Void) {

    let urlRequest = URLRequest(url: URL(string: url)!)

    imageDownloader.download(urlRequest) { response in
      if let image = response.result.value {
        completionHandler(image, urlRequest)
      }
    }
  }
  
  private func setViewWithData() {
    setProfileImage()
    
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
  
  private func showMoreActionSheet(index: Int) {
    let tasklist = self.tasklists[index]
    let title = String(format: "What do you want to do with Tasklist: %@?", tasklist.name)
    let alert = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let editAction = UIAlertAction(title: "Edit", style: .default, handler: { action in
      self.performSegue(withIdentifier: "TaskListDetail", sender: tasklist)
    })
    
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
      action in
      let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
      
      let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        tasklist.delete()
        
        self.taskListCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        //self.taskListCollectionView.reloadData()
        print("Ok button tapped")
      })
      
      let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        print("Cancel button tapped")
      }
      
      dialogMessage.addAction(ok)
      dialogMessage.addAction(cancel)
      
      self.present(dialogMessage, animated: true, completion: nil)
    })
    
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
    } else if segue.identifier == "TaskDetail" {
      let controller = segue.destination as! TaskDetailViewController
      //controller.delegate = self
      
      if sender is TaskList {
        controller.tasklist = sender as? TaskList
      }
    } else if segue.identifier == "TaskListItems" {
      let controller = segue.destination as! TaskListViewController
      if sender is TaskList {
        controller.tasklist = sender as? TaskList
      }
    }
  }
}

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row < tasklists.count {
      let tasklist = tasklists[indexPath.row]
      performSegue(withIdentifier: "TaskListItems", sender: tasklist)
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
      cell.moreView.addTapGestureRecognizer(action: {
        self.showMoreActionSheet(index: indexPath.row)
      })
      
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
    reloadTasks()
  }
  
  func taskListDetailViewController(_ controller: TaskListDetailViewController, didFinishEditing tasklist: TaskList) {
    reloadTasks()
  }
}

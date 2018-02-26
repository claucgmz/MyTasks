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
import FacebookLogin
import FacebookCore
import SlideMenuControllerSwift

class HomeViewController: UIViewController {
  
  @IBOutlet private var layerContainer: LayerContainerView!
  @IBOutlet private weak var taskListCollectionView: UICollectionView!
  @IBOutlet private weak var userProfileImage: UIImageView!
  @IBOutlet private weak var welcomeLabel: UILabel!
  @IBOutlet private weak var todaySummaryLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  
  private var tasklists: LinkingObjects<TaskList>!
  private var user: User?
  private let imageCache = AutoPurgingImageCache()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    user = RealmService.getLoggedUser()
    tasklists = user?.tasklists
    setBackgroundColor()
    updateUI()
    registerNibs()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    taskListCollectionView.reloadData()
    updateTotalTasksForToday()
  }
  
  // MARK: -  Private methods
  private func registerNibs() {
    let taskItemCellNib = UINib(nibName: "TaskListCollectionCell", bundle: nil)
    taskListCollectionView.register(taskItemCellNib, forCellWithReuseIdentifier: TaskListCollectionCell.reusableId)
    
    let addTaskItemCellNib = UINib(nibName: "AddTaskListCollectionCell", bundle: nil)
    taskListCollectionView.register(addTaskItemCellNib, forCellWithReuseIdentifier: AddTaskListCollectionCell.reusableId)
  }
  
  private func setBackgroundColor() {
    let visibleItems = taskListCollectionView.indexPathsForVisibleItems
    var indexPath = IndexPath(row: 0, section: 0)
    
    if visibleItems.count > 0 {
      indexPath = visibleItems.first!
    }
    
    for item in visibleItems {
      if item.row < indexPath.row {
        indexPath = item
      }
    }
    
    if indexPath.row < tasklists.count {
      let list = tasklists[indexPath.row]
      layerContainer.setGradientLayer(colors: [list.color.cgColor, list.color.withAlphaComponent(0.5).cgColor])
    }
  }
  
  private func reloadTasks() {
    taskListCollectionView.reloadData()
    navigationController?.popViewController(animated:true)
  }
  
  private func setProfileImage() {
    if let url = user?.imageURL {
      let urlRequest = URLRequest(url: URL(string: url)!)
      
      guard let cachedAvatarImage = imageCache.image(for: urlRequest, withIdentifier: "avatar") else {
        downloadImage(from: url, completionHandler: { image, urlRequest in
          let avatarImage = image.af_imageRoundedIntoCircle()
          self.imageCache.add(avatarImage, withIdentifier: "avatar")
          self.userProfileImage.image = avatarImage
        })
        return
      }
      
      userProfileImage.image = cachedAvatarImage
    }
  }
  
  private func downloadImage(from url: String, completionHandler: @escaping(Image, URLRequest) -> Void) {
    let urlRequest = URLRequest(url: URL(string: url)!)
    
    ImageDownloader.default.download(urlRequest) { response in
      if let image = response.result.value {
        completionHandler(image, urlRequest)
      }
    }
  }
  
  private func updateUI() {
    setProfileImage()
    
    if let firstName = user?.firstName {
      welcomeLabel.text = "\(NSLocalizedString("greeting", comment: "")), \(firstName)"
    }
    
    let date = Date()
    let locale = Locale.current
    
    if let region = locale.regionCode {
      let dateString = date.toString(withLocale: region)
      dateLabel.text = "\(NSLocalizedString("today", comment: "")): \(dateString)".uppercased()
    }
    
    updateTotalTasksForToday()
  }
  
  private func updateTotalTasksForToday() {
    todaySummaryLabel.text = String(format: NSLocalizedString("tasks_for_today", comment: ""),"\(user?.totalTasksForToday ?? 0)")
  }
  
  private func showMoreActionSheet(index: Int) {
    let tasklist = self.tasklists[index]
    let title = String(format: NSLocalizedString("alert_title", comment:""), tasklist.name)
    let alert = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
    
    let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
    let editAction = UIAlertAction(title: NSLocalizedString("edit_list", comment: ""), style: .default, handler: { action in
      self.performSegue(withIdentifier: "TaskListDetail", sender: tasklist)
    })
    
    let deleteAction = UIAlertAction(title: NSLocalizedString("delete_list", comment: ""), style: .destructive, handler: {
      action in
      let dialogMessage = UIAlertController(title: NSLocalizedString("confirm", comment: ""), message: NSLocalizedString("confirm_subtitle", comment: ""), preferredStyle: .alert)
      
      let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (action) -> Void in
        tasklist.hardDelete()
        
        self.taskListCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
      })
      
      let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel) { (action) -> Void in
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
  
  @IBAction private func openMenuAction(_ sender: Any) {
    slideMenuController()?.delegate = self
    slideMenuController()?.openLeft()
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

// MARK: -  Collection delegate methods
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

// MARK: -  Collection data source methods
extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tasklists.count + 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.row < tasklists.count {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskListCollectionCell.reusableId, for: indexPath) as! TaskListCollectionCell
      cell.roundCorners(withRadius: 10)
      let taskList = tasklists[indexPath.row]
      cell.progressView.configure(with: taskList)
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

// MARK: -  Collection flowlayout methods
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

// MARK: -  Slide menu delegate methods
extension HomeViewController: SlideMenuControllerDelegate {
  func leftWillClose() {
    if user?.isLoggedIn == false {
      if let wd = UIApplication.shared.delegate?.window {
        var vc = wd!.rootViewController
        
        if(vc is UINavigationController) {
          vc = (vc as! UINavigationController).visibleViewController
          print("sth else")
        }
        
        if(vc is LoginViewController){
          navigationController?.popViewController(animated: true)
        }
      }
    }
  }
  
  func leftWillOpen() {
    let controller = slideMenuController()?.leftViewController as? MenuViewController
    guard let cachedAvatarImage = imageCache.image(withIdentifier: "avatar") else {
      return
    }
    controller?.userProfileImage.image = cachedAvatarImage
  }
}

extension HomeViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    setBackgroundColor()
  }
}

//
//  HomeViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class HomeViewController: UIViewController {
  @IBOutlet private var layerContainer: LayerContainerView!
  @IBOutlet private weak var taskListCollectionView: UICollectionView!
  @IBOutlet private weak var userProfileImage: UIImageView!
  @IBOutlet private weak var welcomeLabel: UILabel!
  @IBOutlet private weak var todaySummaryLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  private var tasklists = [Tasklist]()
  private var user: User!
  private var slideMenu: SlideMenuController?
  var successMessage: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    slideMenu = slideMenuController()
    user = AuthServer.user()
    self.updateUserUI()
    if let message = successMessage {
      self.showSnackbar(with: message)
    }
    getTasklists()
    registerNibs()
    updateUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  // MARK: - Private methods
  private func registerNibs() {
    taskListCollectionView.register(UINib(nibName: TaskListCollectionCell.reusableId, bundle: nil),
                                    forCellWithReuseIdentifier: TaskListCollectionCell.reusableId)
    taskListCollectionView.register(UINib(nibName: AddTaskListCollectionCell.reusableId, bundle: nil),
                                    forCellWithReuseIdentifier: AddTaskListCollectionCell.reusableId)
  }

  private func getTasklists() {
    DataHelper.getTasklists(completionHandler: { tasklists in
      self.tasklists = tasklists
      self.taskListCollectionView.reloadData()
    })
  }
  
  private func setBackgroundColor() {
    let visibleItems = taskListCollectionView.indexPathsForVisibleItems
    var indexPath = IndexPath(row: 0, section: 0)
    if !visibleItems.isEmpty {
      indexPath = visibleItems.first!
    }
    for item in visibleItems where item.row < indexPath.row {
      indexPath = item
    }
    if indexPath.row < tasklists.count {
      let list = tasklists[indexPath.row]
      layerContainer.setGradientLayer(colors: [list.color.cgColor, list.color.withAlphaComponent(0.5).cgColor])
    }
  }
  
  private func updateUI() {
    setBackgroundColor()
    if let region = Locale.current.regionCode {
      let dateString = Date().toString(withLocale: region)
      dateLabel.text = "\("today".localized): \(dateString)".uppercased()
    }
  }
  
  private func updateUserUI() {
    if !user.facebookId.isEmpty {
      ImageManager.shared.get(from: user.imageURL, completionHandler: { (image) in
        self.userProfileImage.image = image
      })
    } else {
      self.userProfileImage.image = UIImage(named: "generalavatar")
    }
    
    welcomeLabel.text = "\("greeting".localized), \(user.displayName)"
  }
  
  private func updateTotalTasksForToday() {
    todaySummaryLabel.text = String(format: "tasks_for_today".localized, "\(String(describing: user.totalTasksForToday))")
  }

  private func showMoreActions(row: Int) {
    let tasklist = self.tasklists[row]
    let actions = [AlertView.action(title: "cancel".localized, style: .cancel),
                   AlertView.action(title: "edit_list".localized, handler: {
                    self.performSegue(withIdentifier: "TaskListDetail", sender: tasklist)
                   }),
                   AlertView.action(title: "delete_list".localized, style: .destructive, handler: {
                    self.showConfirmationAlert(for: tasklist, row: row)
                   })]
    AlertView.show(view: self, title: String(format: "alert_edit_list_title".localized, tasklist.name), actions: actions, style: .actionSheet)
  }
  
  private func showConfirmationAlert(for tasklist: Tasklist, row: Int) {
    let actions = [AlertView.action(title: "ok".localized, handler: { self.delete(tasklist: tasklist) }),
                   AlertView.action(title: "cancel".localized, style: .cancel)]
    AlertView.show(view: self, title: "confirm".localized, message: "confirm_subtitle".localized, actions: actions, style: .alert)
  }
  
  private func delete(tasklist: Tasklist) {
    DataHelper.delete(tasklist)
  }
  
  private func segueToLoginViewController() {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      let rootController =  UIStoryboard(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: MainLoginVC.reusableId)
      appDelegate.window?.rootViewController = rootController
    }
  }
  
  // MARK: - action methods
  @IBAction private func openMenuAction(_ sender: Any) {
    slideMenu?.delegate = self
    slideMenu?.openLeft()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TaskListDetail" {
      guard let controller = segue.destination as? TaskListDetailViewController else {
        return
      }
      controller.delegate = self
      if sender is Tasklist {
        controller.tasklistToEdit = sender as? Tasklist
      }
    } else if segue.identifier == "TaskListItems" {
      guard let controller = segue.destination as? TaskListViewController else {
        return
      }
      if sender is Tasklist {
        controller.tasklist = sender as? Tasklist
      }
    }
  }
}

// MARK: - Collection delegate methods
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

// MARK: - Collection data source methods
extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tasklists.count + 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.row < tasklists.count {
      let taskList = tasklists[indexPath.row]
      let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: TaskListCollectionCell.reusableId, for: indexPath) as? TaskListCollectionCell)!
      cell.roundCorners(withRadius: 10)
      cell.progressView.configure(with: taskList)
      cell.moreView.addTapGestureRecognizer(action: {
        self.showMoreActions(row: indexPath.row)
      })
      return cell
    } else {
      let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: AddTaskListCollectionCell.reusableId, for: indexPath) as? AddTaskListCollectionCell)!
      cell.roundCorners(withRadius: 10)
      return cell
    }
  }
}

// MARK: - Collection flowlayout methods
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width*0.8, height: collectionView.frame.height)
  }
}

extension HomeViewController: TaskListDetailViewControllerDelegate {
  func taskListDetailViewController(_ controller: TaskListDetailViewController) {
    navigationController?.popViewController(animated: true)
    getTasklists()
  }
}

// MARK: - Slide menu delegate methods
extension HomeViewController: SlideMenuControllerDelegate {
  func leftWillClose() {
    if AuthServer.currentUser == nil {
      segueToLoginViewController()
    }
  }
  func leftWillOpen() {
    let controller = slideMenu?.leftViewController as? MenuViewController
    if let imageView = controller?.userProfileImage, !user.facebookId.isEmpty {
      ImageManager.shared.get(from: user.imageURL, completionHandler: { (image) in
        imageView.image = image
      })
    }
    
   controller?.userName.text = user.displayName
  }
}

// MARK: - ScrollView delegate methods
extension HomeViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    setBackgroundColor()
  }
}

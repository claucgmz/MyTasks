//
//  HomeViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import RealmSwift
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
  private var slideMenu: SlideMenuController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    slideMenu = slideMenuController()
    user = RealmService.getLoggedUser()
    tasklists = user?.tasklists
    registerNibs()
    updateUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    taskListCollectionView.reloadData()
    updateTotalTasksForToday()
  }
  
  // MARK: -  Private methods
  private func registerNibs() {
    taskListCollectionView.register(UINib(nibName: TaskListCollectionCell.reusableId, bundle: nil), forCellWithReuseIdentifier: TaskListCollectionCell.reusableId)
    taskListCollectionView.register(UINib(nibName: AddTaskListCollectionCell.reusableId, bundle: nil), forCellWithReuseIdentifier: AddTaskListCollectionCell.reusableId)
  }
  
  private func setBackgroundColor() {
    let visibleItems = taskListCollectionView.indexPathsForVisibleItems
    var indexPath = IndexPath(row: 0, section: 0)
    if visibleItems.count > 0 { indexPath = visibleItems.first! }
    for item in visibleItems {
      if item.row < indexPath.row { indexPath = item }
    }
    if indexPath.row < tasklists.count {
      let list = tasklists[indexPath.row]
      layerContainer.setGradientLayer(colors: [list.color.cgColor, list.color.withAlphaComponent(0.5).cgColor])
    }
  }
  
  private func updateUI() {
    setBackgroundColor()
    setUserImage(to: userProfileImage)
    if let firstName = user?.firstName { welcomeLabel.text = "\("greeting".localized), \(firstName)" }
    if let region = Locale.current.regionCode {
      let dateString = Date().toString(withLocale: region)
      dateLabel.text = "\("today".localized): \(dateString)".uppercased()
    }
    updateTotalTasksForToday()
  }
  
  private func updateTotalTasksForToday() {
    todaySummaryLabel.text = String(format: "tasks_for_today".localized,"\(user?.totalTasksForToday ?? 0)")
  }
  
  private func setUserImage(to imageView: UIImageView) {
    if let url = user?.imageURL { ImageManager.shared.get(from: url, completionHandler: { image in imageView.image = image }) }
  }
  
  private func showMoreActions(row: Int) {
    let tasklist = self.tasklists[row]
    let actions = [AlertView.action(title: "cancel".localized, style: .cancel),
                   AlertView.action(title: "edit_list".localized, handler: { self.performSegue(withIdentifier: "TaskListDetail", sender: tasklist) }),
                   AlertView.action(title: "delete_list".localized, style: .destructive, handler: { self.showConfirmationAlert(for: tasklist, row: row) })]
    AlertView.show(view: self, title: String(format: "alert_title".localized, tasklist.name), actions: actions, style: .actionSheet)
  }
  
  private func showConfirmationAlert(for tasklist: TaskList, row: Int) {
    let actions = [AlertView.action(title: "ok".localized,handler: { self.delete(tasklist: tasklist, row: row) }),
                   AlertView.action(title: "cancel".localized, style: .cancel)]
    AlertView.show(view: self, title: "confirm".localized, message: "confirm_subtitle".localized, actions: actions, style: .alert)
  }
  
  private func delete(tasklist: TaskList, row: Int) {
    tasklist.hardDelete()
    self.taskListCollectionView.deleteItems(at: [IndexPath(row: row, section: 0)])
  }
  
  private func segueToLoginViewController() {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      let rootController =  UIStoryboard(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier:LoginViewController.reusableId)
      appDelegate.window?.rootViewController = rootController
    }
  }
  
  // MARK: -  action methods
  @IBAction private func openMenuAction(_ sender: Any) {
    slideMenu?.delegate = self
    slideMenu?.openLeft()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TaskListDetail" {
      let controller = segue.destination as! TaskListDetailViewController
      controller.delegate = self
      if sender is TaskList { controller.tasklistToEdit = sender as? TaskList }
    } else if segue.identifier == "TaskDetail" {
      let controller = segue.destination as! TaskDetailViewController
      if sender is TaskList { controller.tasklist = sender as? TaskList }
    } else if segue.identifier == "TaskListItems" {
      let controller = segue.destination as! TaskListViewController
      if sender is TaskList { controller.tasklist = sender as? TaskList }
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
      let taskList = tasklists[indexPath.row]
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskListCollectionCell.reusableId, for: indexPath) as! TaskListCollectionCell
      cell.roundCorners(withRadius: 10)
      cell.progressView.configure(with: taskList)
      cell.moreView.addTapGestureRecognizer(action: { self.showMoreActions(row: indexPath.row) })
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
  func taskListDetailViewController(_ controller: TaskListDetailViewController) {
    taskListCollectionView.reloadData()
    navigationController?.popViewController(animated:true)
  }
}

// MARK: -  Slide menu delegate methods
extension HomeViewController: SlideMenuControllerDelegate {
  func leftWillClose() {
    if user?.isLoggedIn == false { segueToLoginViewController() }
  }
  func leftWillOpen() {
    let controller = slideMenu?.leftViewController as? MenuViewController
    if let imageView = controller?.userProfileImage { setUserImage(to: imageView) }
    if let firstName = user?.firstName, let lastName = user?.lastName { controller?.userName.text = "\(firstName) \(lastName)" }
  }
}

// MARK: -  ScrollView delegate methods
extension HomeViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    setBackgroundColor()
  }
}

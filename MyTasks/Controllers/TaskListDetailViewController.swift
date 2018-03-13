//
//  TaskListDetailViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

protocol TaskListDetailViewControllerDelegate: class {
  func taskListDetailViewController(_ controller: TaskListDetailViewController)
}

class TaskListDetailViewController: UIViewController {
  @IBOutlet private weak var mainActionButton: UIButton!
  private var taskListDetailTableViewController: TaskListDetailTableViewController?
  private var user: User!
  var tasklistToEdit: Tasklist?
  weak var delegate: TaskListDetailViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    taskListDetailTableViewController = childViewControllers.first as? TaskListDetailTableViewController
    updateUI()
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TaskListDetailTable" {
      let controller = (segue.destination as? TaskListDetailTableViewController)!
      controller.delegate = self
      controller.tasklistToEdit = tasklistToEdit
    }
  }
  // MARK: - private methods
  private func updateUI() {
    mainActionButton.setTitle("save".localized, for: .normal)
    if tasklistToEdit != nil {
      title = "edit_list".localized
      mainActionButton.didEnable(true)
    } else {
      title = "add_list".localized
      mainActionButton.didEnable(false)
    }
  }
  // MARK: - action methods
  @IBAction private func done() {
    guard let name = taskListDetailTableViewController?.listNameText,
      let icon = taskListDetailTableViewController?.selectedIcon,
      let color = taskListDetailTableViewController?.selectedColor else { return }
    let tasklist = Tasklist(name: name, icon: icon, color: color)
    
    if tasklistToEdit != nil, let id = tasklistToEdit?.id {
      tasklist.id = id
    }
    TasklistBridge.save(tasklist)
    delegate?.taskListDetailViewController(self)
  }
}

extension TaskListDetailViewController: TaskListDetailTableViewControllerDelegate {
  func taskListDetailTableViewController(_ controller: TaskListDetailTableViewController, didEnableButton enable: Bool) {
    mainActionButton.didEnable(enable)
  }
  func taskListDetailTableViewController(_ controller: TaskListDetailTableViewController, keyboardWillShow show: Bool, with height: CGFloat) {
    self.adjustView(with: height, visibleKeyboard: show)
  }
}

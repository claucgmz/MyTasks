//
//  TaskListViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

protocol TaskListViewControllerDelegate: class {
  func taskListViewController(_ controller: TaskListViewController, didFinishAdding task: Task, in tasklist: TaskList)
  func taskListViewController(_ controller: TaskListViewController, didFinishEditing task: Task, in tasklist: TaskList)
}

class TaskListViewController: UIViewController {
  @IBOutlet private weak var mainActionButton: UIButton!
  
  private var taskListTableViewController: TaskListDetailTableViewController?

  weak var delegate: TaskListViewControllerDelegate?
  var tasklist: TaskList?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    taskListTableViewController = childViewControllers.first as? TaskListTableViewController
    if tasklistToEdit != nil {
      title = "Edit TaskList"
      mainActionButton.isEnabled = true
    } else {
      mainActionButton.isEnabled = false
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
}

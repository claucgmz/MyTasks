//
//  TaskListDetailViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

protocol TaskListDetailViewControllerDelegate: class {
  func taskListDetailViewController(_ controller: TaskListDetailViewController, didFinishAdding tasklist: TaskList)
}

class TaskListDetailViewController: UIViewController {
  
  @IBOutlet private weak var mainActionButton: UIButton!
  
  private var taskListDetailTableViewController: TaskListDetailTableViewController?
  
  weak var delegate: TaskListDetailViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    taskListDetailTableViewController = childViewControllers.first as? TaskListDetailTableViewController
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TaskListDetailTable" {
      let controller = segue.destination as! TaskListDetailTableViewController
      controller.delegate = self
    }
  }
  
  private func adjustForKeyboard(with height: CGFloat, show: Bool) {
    let newHeight = show == true ? view.frame.height - height : view.frame.height + height
    let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: newHeight)
    view.frame = frame
  }
  
  @IBAction private func done() {

    guard let name = taskListDetailTableViewController?.listNameText, let icon = taskListDetailTableViewController?.selectedIcon, let color = taskListDetailTableViewController?.selectedColor else {
      return
    }
    
    let tasklist = TaskList(name: name, icon: icon)
    tasklist.color = color
    
    delegate?.taskListDetailViewController(self, didFinishAdding: tasklist)
  }
}

extension TaskListDetailViewController: TaskListDetailTableViewControllerDelegate {
  func taskListDetailTableViewController(_ controller: TaskListDetailTableViewController, didEnableButton enable: Bool) {
    mainActionButton.isEnabled = enable
    if enable {
      mainActionButton.alpha = 1.0
    } else {
      mainActionButton.alpha = 0.6
    }
  }
  
  func taskListDetailTableViewController(_ controller: TaskListDetailTableViewController, keyboardWillShow show: Bool, with height: CGFloat) {
    adjustForKeyboard(with: height, show: show)
  }
}

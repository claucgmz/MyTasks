//
//  AddTaskListViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

protocol AddTaskListViewControllerDelegate: class {
  func addTaskListTableViewController(_ controller: AddTaskListViewController, didFinishAdding tasklist: TaskList)
}

class AddTaskListViewController: UIViewController {
  
  @IBOutlet private weak var mainActionButton: UIButton!
  
  private var addTaskListTableViewController: AddTaskListTableViewController?
  
  weak var delegate: AddTaskListViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addTaskListTableViewController = childViewControllers.first as? AddTaskListTableViewController
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddTaskListTable" {
      let controller = segue.destination as! AddTaskListTableViewController
      controller.delegate = self
    }
  }
  
  private func adjustForKeyboard(with height: CGFloat, show: Bool) {
    let newHeight = show == true ? view.frame.height - height : view.frame.height + height
    let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: newHeight)
    view.frame = frame
  }
  
  @IBAction private func done() {

    guard let name = addTaskListTableViewController?.listNameText, let icon = addTaskListTableViewController?.selectedIcon, let color = addTaskListTableViewController?.selectedColor else {
      return
    }
    
    let tasklist = TaskList(name: name, icon: icon)
    tasklist.color = color
    
    delegate?.addTaskListTableViewController(self, didFinishAdding: tasklist)
  }
}

extension AddTaskListViewController: AddTaskListTableViewControllerDelegate {
  func addTaskListTableViewController(_ controller: AddTaskListTableViewController, didEnableButton enable: Bool) {
    mainActionButton.isEnabled = enable
    if enable {
      mainActionButton.alpha = 1.0
    } else {
      mainActionButton.alpha = 0.6
    }
  }
  
  func addTaskListTableViewController(_ controller: AddTaskListTableViewController, keyboardWillShow show: Bool, with height: CGFloat) {
    adjustForKeyboard(with: height, show: show)
  }
}

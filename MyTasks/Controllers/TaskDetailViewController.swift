//
//  TaskDetailViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
  @IBOutlet private weak var mainActionButton: UIButton!
  private var taskDetailTableViewController: TaskDetailTableViewController?
  var tasklist: TaskList?
  var taskToEdit: TaskItem?

  override func viewDidLoad() {
    super.viewDidLoad()
    taskDetailTableViewController = childViewControllers.first as? TaskDetailTableViewController
    taskDetailTableViewController?.tasklist = tasklist
    updateUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TaskDetailTable" {
      let controller = segue.destination as! TaskDetailTableViewController
      controller.delegate = self
    }
  }
  
  private func updateUI() {
    if taskToEdit != nil {
      title = "edit_task".localized
      mainActionButton.didEnable(true)
      taskDetailTableViewController?.taskToEdit = taskToEdit
      if let date = taskToEdit?.dueDate { taskDetailTableViewController?.dueDate = date }
      if let text = taskToEdit?.text { taskDetailTableViewController?.taskText = text }
    } else {
      title = "add_task".localized
      mainActionButton.didEnable(false)
    }
    mainActionButton.setTitle("save".localized, for: .normal)
  }
  
  @IBAction private func done() {
    guard let text = taskDetailTableViewController?.taskText, let date = taskDetailTableViewController?.dueDate,  let toTaskList = taskDetailTableViewController?.tasklist else {
      return
    }
    if let taskToEdit = taskToEdit {
      taskToEdit.update(text: text, date: date, moveTo: (tasklist?.id != toTaskList.id ? toTaskList : tasklist))
    } else {
      let task = TaskItem(text: text, date: date)
      task.add(to: toTaskList)
      tasklist = toTaskList
    }
    self.navigationController?.popViewController(animated:true)
  }
}

extension TaskDetailViewController: FormWithButtonDelegate {
  func formWithButtonDelegate(_ controller: UIViewController, keyboardWillShow show: Bool, with height: CGFloat) {
    self.adjustView(with: height, visibleKeyboard: show)
  }
  
  func formWithButtonDelegate(_ controller: UIViewController, didEnableButton enable: Bool) {
    mainActionButton.didEnable(enable)
  }
}

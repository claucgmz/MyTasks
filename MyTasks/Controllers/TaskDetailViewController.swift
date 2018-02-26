//
//  TaskDetailViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

protocol TaskDetailViewControllerDelegate: class {
  func taskDetailViewController(_ controller: TaskDetailViewController, didFinishAdding task: TaskItem, in tasklist: TaskList)
  func taskDetailViewController(_ controller: TaskDetailViewController, didFinishEditing task: TaskItem, in tasklist: TaskList)
}

class TaskDetailViewController: UIViewController {
  @IBOutlet private weak var mainActionButton: UIButton!
  
  private var taskDetailTableViewController: TaskDetailTableViewController?
  
  weak var delegate: TaskDetailViewControllerDelegate?
  
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
  
  private func adjustForKeyboard(with height: CGFloat, show: Bool) {
    let newHeight = show == true ? view.frame.height - height : view.frame.height + height
    let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: newHeight)
    view.frame = frame
  }
  
  private func updateUI() {
    if taskToEdit != nil {
      title = NSLocalizedString("edit_task", comment: "")
      mainActionButton.didEnable(true)
      taskDetailTableViewController?.taskToEdit = taskToEdit
      
      if let date = taskToEdit?.dueDate {
        taskDetailTableViewController?.dueDate = date
      }
      
      if let text = taskToEdit?.text {
        taskDetailTableViewController?.taskText = text
      }
    } else {
      title = NSLocalizedString("add_task", comment: "")
      mainActionButton.didEnable(false)
    }
    
    mainActionButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
  }
  
  @IBAction private func done() {
    guard let text = taskDetailTableViewController?.taskText, let date = taskDetailTableViewController?.dueDate,  let toTaskList = taskDetailTableViewController?.tasklist else {
      return
    }
    
    if let taskToEdit = taskToEdit {
      taskToEdit.update(text: text, date: date, moveTo: (tasklist?.id != toTaskList.id ? toTaskList : tasklist))
      if let tasklist = tasklist {
        delegate?.taskDetailViewController(self, didFinishEditing: taskToEdit, in: tasklist)
      }
      
    } else {
      let task = TaskItem(text: text, date: date)
      task.add(to: toTaskList)
      tasklist = toTaskList
      if let tasklist = tasklist {
        delegate?.taskDetailViewController(self, didFinishAdding: task, in: tasklist)
      }
    }
  }
}

extension TaskDetailViewController: FormWithButtonDelegate {
  func formWithButtonDelegate(_ controller: UIViewController, keyboardWillShow show: Bool, with height: CGFloat) {
    let newHeight = show == true ? view.frame.height - height : view.frame.height + height
    let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: newHeight)
    view.frame = frame
  }
  
  func formWithButtonDelegate(_ controller: UIViewController, didEnableButton enable: Bool) {
    mainActionButton.didEnable(enable)
  }
}

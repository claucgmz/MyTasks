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
    if taskToEdit != nil {
      title = "Edit Task"
      mainActionButton.didEnable(true)
      taskDetailTableViewController?.taskToEdit = taskToEdit
      if let date = taskToEdit?.dueDate {
        taskDetailTableViewController?.dueDate = date
      }
      
      if let text = taskToEdit?.text {
        taskDetailTableViewController?.taskText = text
      }
      
    } else {
      title = "Add Task"
      mainActionButton.didEnable(false)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TaskDetailTable" {
      let controller = segue.destination as! TaskDetailTableViewController
      controller.delegate = self
      //controller.taskToEdit = taskToEdit
    }
  }
  private func adjustForKeyboard(with height: CGFloat, show: Bool) {
    let newHeight = show == true ? view.frame.height - height : view.frame.height + height
    let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: newHeight)
    view.frame = frame
  }
  
  @IBAction private func done() {
    guard let text = taskDetailTableViewController?.taskText, let date = taskDetailTableViewController?.dueDate else {
      return
    }
    
    let task = TaskItem(text: text, date: date)
    
    if let taskToEdit  = taskToEdit {
      tasklist?.update(task: taskToEdit, with: task)
      self.navigationController?.popViewController(animated:true)
      //RealmService.shared.update(tasklistToEdit, with: ["hex": color.toHexString, "categoryIcon": icon.rawValue, "name": name])
      //delegate?.taskListDetailViewController(self, didFinishEditing: tasklistToEdit)
    } else {
      tasklist?.add(task: task)
      print(task)
      self.navigationController?.popViewController(animated:true)
      //RealmService.shared.create(tasklist)
      //delegate?.taskListDetailViewController(self, didFinishAdding: tasklist)
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

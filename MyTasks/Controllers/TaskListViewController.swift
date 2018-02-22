//
//  TaskListViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListViewController: UIViewController {
  @IBOutlet private weak var tasksTableView: UITableView!
  var tasklist: TaskList?
  private var tasks = [TaskListView]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerNibs()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateTasksByDate()
    tasksTableView.reloadData()
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  private func registerNibs() {
    let taskCellNib = UINib(nibName: "TaskCell", bundle: nil)
    tasksTableView.register(taskCellNib, forCellReuseIdentifier: TaskCell.reusableId)
    
    let headerCellNib = UINib(nibName: "TaskListTableHeader", bundle: nil)
    tasksTableView.register(headerCellNib, forHeaderFooterViewReuseIdentifier: "TaskListTableHeader")
  }
  
  private func updateTasksByDate() {
    if let tasksbydate = tasklist?.tasksByDate {
      tasks = tasksbydate
    }
  }
  
  private func updateProgressView() {
    guard let tableView = tasksTableView else { return }
    tableView.reloadSections(IndexSet(integer: 0), with: .middle)
  }
  
  @IBAction func addTaskButtonAction(_ sender: Any) {
    performSegue(withIdentifier: "TaskDetail", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TaskDetail" {
      let controller = segue.destination as! TaskDetailViewController
      controller.tasklist = tasklist
      controller.delegate = self
      
      if sender is TaskItem {
        controller.taskToEdit = sender as? TaskItem
      }
    }
  }
}

extension TaskListViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return tasks.count + 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 0
    }
    
    return tasks[section-1].tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reusableId) as! TaskCell
    let task = tasks[indexPath.section-1].tasks[indexPath.row]
    
    cell.configure(with: task)
    
    cell.checkboxView.addTapGestureRecognizer(action: {
      cell.configure(with: task)
      task.toogleCheckmark()
      tableView.reloadRows(at: [indexPath], with: .automatic)
      self.updateProgressView()
    })
    
    cell.deleteView.addTapGestureRecognizer(action: {
      task.softDelete()
      tableView.beginUpdates()
      tableView.deleteRows(at: [indexPath], with: .automatic)
      self.updateProgressView()
      
      if tableView.numberOfRows(inSection: indexPath.section) == 1 {
        let indexSet = IndexSet(integer: indexPath.section)
        tableView.deleteSections(indexSet, with: .middle)
        self.updateTasksByDate()
      }

      tableView.endUpdates()
    })
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section > 0 {
      let title = NSLocalizedString(tasks[section-1].type.rawValue, comment: "")
      return title
    }
    return ""
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    if section == 0 {
      return 180
    }
    
    return 25
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
}

extension TaskListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let task = tasks[indexPath.section-1].tasks[indexPath.row]
    performSegue(withIdentifier: "TaskDetail", sender: task)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    if section == 0 {
      
      let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TaskListTableHeader") as? TaskListTableHeader
      
      guard let tasklist = tasklist else {
        return nil
      }
      header?.progressView.configure(with: tasklist)
      return header
    }
    return nil
  }
  
}

// MARK - TaskDetailViewController delegate methods
extension TaskListViewController: TaskDetailViewControllerDelegate {
  func taskDetailViewController(_ controller: TaskDetailViewController, didFinishAdding task: TaskItem, in tasklist: TaskList) {
    self.navigationController?.popViewController(animated:true)
    tasksTableView.reloadData()
  }
  
  func taskDetailViewController(_ controller: TaskDetailViewController, didFinishEditing task: TaskItem, in tasklist: TaskList) {
    self.navigationController?.popViewController(animated:true)
    tasksTableView.reloadData()
  }
}

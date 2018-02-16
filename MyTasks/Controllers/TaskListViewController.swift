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
  
  @IBOutlet weak var tasksTableView: UITableView!
  var tasklist: TaskList?
  var tasksOrder = [String]()
  var tasks = [Results<TaskItem>]()
  var notificationToken: NotificationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerNibs()
    addNotification()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateTasksByDate()
    tasksTableView.reloadData()
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  deinit {
    notificationToken?.invalidate()
  }
  
  private func registerNibs() {
    let taskCellNib = UINib(nibName: "TaskCell", bundle: nil)
    tasksTableView.register(taskCellNib, forCellReuseIdentifier: TaskCell.reusableId)
    
    let headerCellNib = UINib(nibName: "TaskListTableHeader", bundle: nil)
    tasksTableView.register(headerCellNib, forHeaderFooterViewReuseIdentifier: "TaskListTableHeader")
  }
  
  private func addNotification() {
    let results = tasklist?.tasks
    notificationToken = results?.observe { [weak self] (changes: RealmCollectionChange) in
      guard let tableView = self?.tasksTableView else { return }
      tableView.reloadSections([0,1], with: .none)
    }
  }
  
  private func updateTasksByDate() {
    let tasksbydate = tasklist?.tasksByDate
    tasks = (tasksbydate?.tasks)!
    tasksOrder = (tasksbydate?.order)!
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
    
    return tasks[section-1].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reusableId) as! TaskCell
    let task = tasks[indexPath.section-1][indexPath.row]
    
    cell.configure(with: task)
    
    cell.checkboxView.addTapGestureRecognizer(action: {
      cell.configure(with: task)
      task.toogleCheckmark()
    })
    
    cell.deleteView.addTapGestureRecognizer(action: {
      task.softDelete()
      
      tableView.beginUpdates()
      if tableView.numberOfRows(inSection: indexPath.section) == 1 {
        let indexSet = IndexSet(arrayLiteral: indexPath.section)
        tableView.deleteSections(indexSet, with: .automatic)
        self.updateTasksByDate()
      }
      else {
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }
      
      tableView.endUpdates()
    })
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section > 0 && tasksOrder.count >= section {
      let title = tasksOrder[section-1]
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
    let task = tasks[indexPath.section-1][indexPath.row]
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

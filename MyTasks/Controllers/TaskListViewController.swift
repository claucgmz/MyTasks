//
//  TaskListViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {
  @IBOutlet private weak var tasksTableView: UITableView!
  var tasklist: TaskList?
  private var tasks = [TaskListView]()
  
  enum cellType: Int {
    case progressHeader = 0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerNibs()
    getFilteredTasks()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getFilteredTasks()
    tasksTableView.reloadData()
  }
  
  // MARK - Private methods
  private func registerNibs() {
    tasksTableView.register(UINib(nibName: TaskCell.reusableId, bundle: nil), forCellReuseIdentifier: TaskCell.reusableId)
    tasksTableView.register(UINib(nibName: TaskListTableHeader.reusableId, bundle: nil), forHeaderFooterViewReuseIdentifier: TaskListTableHeader.reusableId)
  }
  
  private func getFilteredTasks() {
    if let tasksbydate = tasklist?.tasksByDate {
      tasks = tasksbydate
    }
  }
  
  private func reloadRow(at indexPath: IndexPath, tableView: UITableView) {
    UIView.performWithoutAnimation {
      tableView.reloadRows(at: [indexPath], with: .automatic)
      self.updateProgressView()
    }
  }
  
  private func updateProgressView() {
    guard let tableView = tasksTableView else { return }
    tableView.reloadSections(IndexSet(integer: 0), with: .none)
  }
  
  private func complete(task: TaskItem) {
    guard let indexPath = getIndexPath(for: task) else { return }
    task.complete()
    reloadRow(at: indexPath, tableView: tasksTableView)
  }
  
  private func delete(task: TaskItem) {
    guard let indexPath = getIndexPath(for: task) else { return }
    task.softDelete()
    tasksTableView.deleteRows(at: [indexPath], with: .automatic)
    if tasksTableView.numberOfRows(inSection: indexPath.section) == 0 {
      getFilteredTasks()
      UIView.performWithoutAnimation { tasksTableView.deleteSections(IndexSet(integer: indexPath.section), with: .none) }
    }
    UIView.performWithoutAnimation { self.updateProgressView() }
  }
  
  func getIndexPath(for task: TaskItem) -> IndexPath? {
    guard let section = tasks.index(where: { tasklistView in tasklistView.type == task.dateType }) else { return nil }
    guard let row = tasks[section.hashValue].tasks.index(where: { taskItem in taskItem == task }) else { return nil }
    return IndexPath(row: row, section: section + 1)
  }
  
  // MARK - action methods
  @IBAction func addTaskButtonAction(_ sender: Any) {
    performSegue(withIdentifier: "TaskDetail", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TaskDetail" {
      let controller = segue.destination as! TaskDetailViewController
      controller.tasklist = tasklist
      if sender is TaskItem { controller.taskToEdit = sender as? TaskItem }
    }
  }
}

extension TaskListViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return tasks.count + 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == cellType.progressHeader.rawValue { return 0 }
    return tasks[section-1].tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reusableId) as! TaskCell
    let task = tasks[indexPath.section-1].tasks[indexPath.row]
    cell.configure(with: task)
    cell.checkboxView.addTapGestureRecognizer(action: {
      self.complete(task: task)
    })
    cell.deleteView.addTapGestureRecognizer(action: {
      self.delete(task: task)
    })
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section > cellType.progressHeader.rawValue { return tasks[section-1].type.rawValue.localized }
    return ""
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == cellType.progressHeader.rawValue { return 180 }
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
    if section == cellType.progressHeader.rawValue {
      let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TaskListTableHeader.reusableId) as? TaskListTableHeader
      guard let tasklist = tasklist else {
        return nil
      }
      header?.progressView.configure(with: tasklist)
      return header
    }
    return nil
  }
}

//
//  TaskListViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class TaskListViewController: UIViewController {
  @IBOutlet private weak var tasksTableView: UITableView!
  var tasklist: Tasklist?
  private var tasksViews = [TaskListView]()
  
  enum CellType: Int {
    case progressHeader = 0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getFilteredTasks()
    tasksTableView.emptyDataSetSource = self
    tasksTableView.emptyDataSetDelegate = self
    registerNibs()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  // MARK: - Private methods
  private func registerNibs() {
    tasksTableView.register(UINib(nibName: TaskCell.reusableId, bundle: nil), forCellReuseIdentifier: TaskCell.reusableId)
    tasksTableView.register(UINib(nibName: TaskListTableHeader.reusableId, bundle: nil), forHeaderFooterViewReuseIdentifier: TaskListTableHeader.reusableId)
  }
  
  private func getFilteredTasks() {
    guard let tasklist = tasklist else {
      return
    }
    let dateTypes: [DateType] = [.today, .tomorrow, .later, .pastDueDate]
    for (index, dateType) in dateTypes.enumerated() {
      tasklist.getTasks(for: dateType, order: index, completionHandler: { 
        self.tasksViews = tasklist.tasksViews
        self.tasksTableView.reloadData()
      })
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
  
  private func complete(task: Task) {
    guard let indexPath = getIndexPath(for: task) else { return }
    task.checked = !task.checked
    TaskBridge.save(task)
    reloadRow(at: indexPath, tableView: tasksTableView)
  }
  
  private func delete(task: Task) {
    TaskBridge.softDelete(task)
    //UIView.performWithoutAnimation { self.updateProgressView() }
  }
  
  func getIndexPath(for task: Task) -> IndexPath? {
    guard let section = tasksViews.index(where: { tasklistView in
      tasklistView.type == task.dateType }) else {
        return nil
    }
    guard let row = tasksViews[section.hashValue].tasks.index(where: { taskV in
        return taskV.id == task.id
    }) else {
      return nil
    }
    
    return IndexPath(row: row, section: section + 1)
  }
  
  // MARK: - action methods
  @IBAction func addTaskButtonAction(_ sender: Any) {
    performSegue(withIdentifier: "TaskDetail", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TaskDetail" {
      guard let controller = segue.destination as? TaskDetailViewController else {
        return
      }
      controller.tasklist = tasklist
      if sender is Task {
        controller.taskToEdit = sender as? Task
      }
    }
  }
}

extension TaskListViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return tasksViews.count + 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == CellType.progressHeader.rawValue { return 0 }
    return tasksViews[section-1].tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: TaskCell.reusableId) as? TaskCell)!
    let task = tasksViews[indexPath.section-1].tasks[indexPath.row]
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
    if section > CellType.progressHeader.rawValue { return tasksViews[section-1].type.rawValue.localized }
    return ""
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == CellType.progressHeader.rawValue { return 180 }
    return 25
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
}

extension TaskListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let task = tasksViews[indexPath.section-1].tasks[indexPath.row]
    performSegue(withIdentifier: "TaskDetail", sender: task)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == CellType.progressHeader.rawValue {
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

extension TaskListViewController: DZNEmptyDataSetSource {
  func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    return UIImage(named: "clipboard")
  }
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "no_tasks".localized)
  }
}

extension TaskListViewController: DZNEmptyDataSetDelegate {
  func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
    return true
  }
}

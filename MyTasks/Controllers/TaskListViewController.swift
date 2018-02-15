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
  var tasks: Results<TaskItem>!
  var tasksbydate = [Results<TaskItem>]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerNibs()
    filterTasks()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  private func registerNibs() {
    let taskCellNib = UINib(nibName: "TaskCell", bundle: nil)
    tasksTableView.register(taskCellNib, forCellReuseIdentifier: TaskCell.reusableId)
    
    let headerCellNib = UINib(nibName: "TaskListTableHeader", bundle: nil)
    tasksTableView.register(headerCellNib, forHeaderFooterViewReuseIdentifier: "TaskListTableHeader")
  }
  
  private func filterTasks() {
    tasks = tasklist?.items.filter("deleted = false")
    let today = Date()
    let todayStart = Calendar.current.startOfDay(for: today)
    let todayEnd: Date = {
      let components = DateComponents(day: 1, second: -1)
      return Calendar.current.date(byAdding: components, to: todayStart)!
    }()
    
    let tomorrowStart: Date = {
      let components = DateComponents(day: 1)
      return Calendar.current.date(byAdding: components, to: todayStart)!
    }()
    
    let tomorrowEnd: Date = {
      let components = DateComponents(day: 1)
      return Calendar.current.date(byAdding: components, to: tomorrowStart)!
    }()
    
    let laterStart: Date = {
      let components = DateComponents(day: 1)
      return Calendar.current.date(byAdding: components, to: tomorrowStart)!
    }()
    
    tasksbydate.append(tasks.filter("dueDate BETWEEN %@", [todayStart, todayEnd]))
    tasksbydate.append(tasks.filter("dueDate BETWEEN %@",[tomorrowStart, tomorrowEnd]))
    tasksbydate.append(tasks.filter("dueDate > %@", laterStart))
    tasksbydate.append(tasks.filter("dueDate < %@", todayStart))
  }
  
  private func reloadTasks() {
    tasksTableView.reloadData()
    navigationController?.popViewController(animated:true)
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
    return 5
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 0 {
      return 0
    }
    
    return tasksbydate[section-1].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reusableId) as! TaskCell
    let task = tasksbydate[indexPath.section-1][indexPath.row]

    cell.configure(with: task)
    
    cell.checkboxView.addTapGestureRecognizer(action: {
      cell.configure(with: task)
      task.toogleCheckmark()
    })
    
    cell.deleteView.addTapGestureRecognizer(action: {
      task.delete()
      self.filterTasks()
      tableView.beginUpdates()
      tableView.deleteRows(at: [indexPath], with: .fade)
      tableView.endUpdates()
    })
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 1 {
      return "Today"
    } else if section == 2 {
      return "Tomorrow"
    } else if section == 3 {
      return "Later"
    }  else if section == 4 {
      return "Past"
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
    let task = tasksbydate[indexPath.section-1][indexPath.row]
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

extension TaskListViewController: TaskDetailViewControllerDelegate {
  func taskDetailViewController(_ controller: TaskDetailViewController, didFinishAdding task: TaskItem, in tasklist: TaskList) {
    reloadTasks()
  }
  
  func taskDetailViewController(_ controller: TaskDetailViewController, didFinishEditing task: TaskItem, in tasklist: TaskList) {
    reloadTasks()
  }
}
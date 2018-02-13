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
  }
  
  private func registerNibs() {
    let taskCellNib = UINib(nibName: "TaskCell", bundle: nil)
    tasksTableView.register(taskCellNib, forCellReuseIdentifier: TaskCell.reusableId)
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
    
    print(tasksbydate[0])
    print(tasksbydate[1])
    print(tasksbydate[2])
  }
  
  @IBAction func addTaskButtonAction(_ sender: Any) {
   performSegue(withIdentifier: "TaskDetail", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TaskDetail" {
      let controller = segue.destination as! TaskDetailViewController
      controller.tasklist = tasklist
      
      if sender is TaskItem {
        controller.taskToEdit = sender as? TaskItem
      }
    }
  }
}

extension TaskListViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
    //return tasksbydate.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasksbydate[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reusableId) as! TaskCell
    let task = tasksbydate[indexPath.section][indexPath.row]
    cell.configure(with: task)
    cell.checkboxView.addTapGestureRecognizer(action: {
      cell.toogleCheckmark(with: !task.checked)
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
    if section == 0 {
      return "Today"
    } else if section == 1 {
      return "Tomorrow"
    } else if section == 2 {
      return "Later"
    }
    
    return ""
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44.0
  }
}

extension TaskListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let task = tasksbydate[indexPath.section][indexPath.row]
    performSegue(withIdentifier: "TaskDetail", sender: task)
  }
}


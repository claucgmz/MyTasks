//
//  TaskListTableViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import RealmSwift

class TaskDetailTableViewController: UITableViewController {
  
  @IBOutlet var mainTableView: UITableView!
  
  var tasklists : Results<TaskList>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerNibs()
    updateView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: - Private methods
  private func registerNibs() {
    let textFieldCellNib = UINib(nibName: "TextFieldCell", bundle: nil)
    mainTableView.register(textFieldCellNib, forCellReuseIdentifier: TextFieldCell.reusableId)
    
    let datePickerCellNib = UINib(nibName: "DatePickerCell", bundle: nil)
    mainTableView.register(datePickerCellNib, forCellReuseIdentifier: DatePickerCell.reusableId)
    
    let taskListCelllNib = UINib(nibName: "TaskListCell", bundle: nil)
    mainTableView.register(taskListCelllNib, forCellReuseIdentifier: TaskListCell.reusableId)
  }
  
  private func updateView() {
    let realm = RealmService.shared.realm
    tasklists = realm.objects(TaskList.self)
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 2 {
      return tasklists.count
    }
    
    return 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = indexPath.section
    
    if section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reusableId) as! TextFieldCell
      return cell
    } else if section == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerCell.reusableId) as! DatePickerCell
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reusableId) as! TaskListCell
      let tasklist = tasklists[indexPath.row]
      cell.configure(with: tasklist)
      return cell
    }
  }
  
  // MARK - Table view delegate
  
}

//
//  TaskDetailTableViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/12/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import RealmSwift

class TaskDetailTableViewController: UITableViewController {
  @IBOutlet var mainTableView: UITableView!
  private var tasklists : Results<TaskList>!
  private var datePickerIsVisible = false
  weak var delegate: FormWithButtonDelegate?
  var taskText = ""
  var dueDate = Date()
  var taskToEdit: TaskItem?
  var tasklist: TaskList?
  
  enum CellType: Int {
    case textField = 0
    case dueDate = 1
    case tasklists = 2
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerNibs()
    tasklists = RealmService.realm.objects(TaskList.self)
    updateDueDateLabel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateDueDateLabel()
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  //MARK: - Private methods
  private func registerNibs() {
    mainTableView.register(UINib(nibName: TextFieldCell.reusableId, bundle: nil), forCellReuseIdentifier: TextFieldCell.reusableId)
    mainTableView.register(UINib(nibName: DueDateCell.reusableId, bundle: nil), forCellReuseIdentifier: DueDateCell.reusableId)
    mainTableView.register(UINib(nibName: DatePickerCell.reusableId, bundle: nil), forCellReuseIdentifier: DatePickerCell.reusableId)
    mainTableView.register(UINib(nibName: TaskListCell.reusableId, bundle: nil), forCellReuseIdentifier: TaskListCell.reusableId)
  }
  private func showDatePicker() {
    datePickerIsVisible = true
    let indexPathDateRow = IndexPath(row: 0, section: 1)
    let indexPathDatePicker = IndexPath(row: 1, section: 1)
    tableView.beginUpdates()
    tableView.insertRows(at: [indexPathDatePicker], with: .fade)
    tableView.reloadRows(at: [indexPathDateRow], with: .none)
    tableView.endUpdates()
  }
  private func hideDatePicker() {
    if datePickerIsVisible {
      datePickerIsVisible = false
      let indexPathDateRow = IndexPath(row: 0, section: 1)
      let indexPathDatePicker = IndexPath(row: 1, section: 1)
      tableView.beginUpdates()
      tableView.reloadRows(at: [indexPathDateRow], with: .none)
      tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
      tableView.endUpdates()
    }
  }
  private func updateDueDateLabel(){
    let indexPathDateRow = IndexPath(row: 0, section: 1)
    if let dueDateCell = tableView.cellForRow(at: indexPathDateRow) {
      dueDateCell.detailTextLabel?.text = dueDate.toString(withFormat: "MMM d, h:mm a")
    }
  }
  @objc private func dateChanged(_ datePicker: UIDatePicker) {
    dueDate = datePicker.date
    updateDueDateLabel()
  }
  //MARK: - getKeyboardHeight method
  @objc func adjustForKeyboard(notification: Notification) {
    let userInfo:NSDictionary = notification.userInfo! as NSDictionary
    let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
    let keyboardRectangle = keyboardFrame.cgRectValue
    let keyboardHeight = keyboardRectangle.height
    if notification.name.rawValue == "UIKeyboardWillHideNotification" {
      delegate?.formWithButtonDelegate(self, keyboardWillShow: false, with: keyboardHeight)
    } else {
      delegate?.formWithButtonDelegate(self, keyboardWillShow: true, with: keyboardHeight)
    }
  }
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case CellType.textField.rawValue:
      return 100
    case CellType.dueDate.rawValue:
      if indexPath.row == 0 {
        return 48
      }
      return 140
    default:
      return 44
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case CellType.dueDate.rawValue:
      if datePickerIsVisible == true { return 1 }
      return 2
    case CellType.tasklists.rawValue:
      return tasklists.count
    default:
      return 1
    }
  }
  private func drawTextFieldCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reusableId) as! TextFieldCell
    cell.taskNameTextField.delegate = self
    cell.taskNameTextField.text = taskText
    return cell
  }
  private func drawDueDateCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 1{
      let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerCell.reusableId) as! DatePickerCell
      cell.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
      cell.datePicker.setDate(dueDate, animated: false)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: DueDateCell.reusableId) as! DueDateCell
      cell.detailTextLabel?.text = dueDate.toString(withFormat: "MMM d, h:mm a")
      return cell
    }
  }
  private func drawTaskListsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reusableId) as! TaskListCell
    let tlist = tasklists[indexPath.row]
    cell.configure(with: tlist, isSelected: tlist.id == tasklist?.id)
    return cell
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case CellType.textField.rawValue:
      return drawTextFieldCell(tableView, indexPath: indexPath)
    case CellType.dueDate.rawValue:
      return drawDueDateCell(tableView, indexPath: indexPath)
    default:
      return drawTaskListsCell(tableView, indexPath: indexPath)
    }
  }
  
  // MARK - Table view delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 && indexPath.row == 0 {
      if !datePickerIsVisible {
        showDatePicker()
      } else {
        hideDatePicker()
      }
    } else if indexPath.section == 2 {
      tasklist = tasklists[indexPath.row]
      tableView.reloadData()
    }
  }
}

extension TaskDetailTableViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in:oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    taskText = newText
    delegate?.formWithButtonDelegate(self, didEnableButton: !taskText.isEmpty)
    return true
  }
}

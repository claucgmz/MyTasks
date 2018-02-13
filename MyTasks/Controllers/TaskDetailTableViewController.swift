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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerNibs()
    updateView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
  
  @objc private func dateChanged(_ datePicker: UIDatePicker) {
    dueDate = datePicker.date
    print(dueDate)
    //updateDueDateLabel()
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
      cell.taskNameTextField.delegate = self
      cell.taskNameTextField.text = taskText
      return cell
    } else if section == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerCell.reusableId) as! DatePickerCell
      cell.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
      cell.datePicker.setDate(dueDate, animated: false)
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

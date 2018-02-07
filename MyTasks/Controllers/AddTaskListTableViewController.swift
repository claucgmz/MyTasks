//
//  AddTaskListTableViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/7/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

protocol AddTaskListTableViewControllerDelegate: class {
  func addTaskListTableViewController(_ controller: AddTaskListTableViewController, keyboardWillShow show: Bool, withHeight height: CGFloat)
}

class AddTaskListTableViewController: UITableViewController {
  
  @IBOutlet private weak var listNameTextField: UITextField!
  
  weak var delegate: AddTaskListTableViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    listNameTextField.resignFirstResponder()
  }
  
  //MARK: - getKeyboardHeight
  
  @objc func adjustForKeyboard(notification: Notification) {
    let userInfo:NSDictionary = notification.userInfo! as NSDictionary
    let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
    let keyboardRectangle = keyboardFrame.cgRectValue
    let keyboardHeight = keyboardRectangle.height

    if notification.name.rawValue == "UIKeyboardWillHideNotification" {
      delegate?.addTaskListTableViewController(self, keyboardWillShow: false, withHeight: keyboardHeight)
    } else {
      delegate?.addTaskListTableViewController(self, keyboardWillShow: true, withHeight: keyboardHeight)
    }
  }
}


extension AddTaskListTableViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    print("textFieldDidBeginEditing")
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    print("textFieldDidEndEditing")
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    print("textFieldShouldReturn")
    return true
  }
}

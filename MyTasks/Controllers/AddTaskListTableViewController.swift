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
  
  @IBOutlet private weak var colorPickerView: UICollectionView!
  @IBOutlet private weak var iconPickerView: UICollectionView!
  @IBOutlet private weak var listNameTextField: UITextField!
  
  weak var delegate: AddTaskListTableViewControllerDelegate?
  let colors = UIColor.ColorPicker.all
  let icons = TaskList.icons
  var selectedColorIndex: Int? = nil
  var selectedColor: UIColor? = nil
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerNibs()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  private func registerNibs() {
    let colorPickerCellNib = UINib(nibName: "ColorPickerCollectionCell", bundle: nil)
    colorPickerView.register(colorPickerCellNib, forCellWithReuseIdentifier: ColorPickerCollectionCell.reusableId)
    
    let iconPickerCellNib = UINib(nibName: "IconPickerCollectionCell", bundle: nil)
    iconPickerView.register(iconPickerCellNib, forCellWithReuseIdentifier: IconPickerCollectionCell.reusableId)
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
  
  //MARK: - Private methods
  private func didSelectColor(index: Int) {
    selectedColorIndex = index
    let color = colors[index]
    selectedColor = color
    iconPickerView.reloadData()
  }
}

extension AddTaskListTableViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    listNameTextField.resignFirstResponder()
    
    if collectionView === colorPickerView {
      didSelectColor(index: indexPath.row)
    }
    else {

    }
  }
}

extension AddTaskListTableViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView === colorPickerView {
      return colors.count
    }
    else {
      return icons.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView === colorPickerView {
      let cell = colorPickerView.dequeueReusableCell(withReuseIdentifier: ColorPickerCollectionCell.reusableId, for: indexPath) as! ColorPickerCollectionCell
      let color = colors[indexPath.row]
      cell.configure(withColor: color)
      return cell
    }
    else {
      let cell = iconPickerView.dequeueReusableCell(withReuseIdentifier: IconPickerCollectionCell.reusableId, for: indexPath) as! IconPickerCollectionCell
      let icon = icons[indexPath.row]
      cell.configure(withIcon: icon, color: selectedColor)
      return cell
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

//
//  AddTaskListTableViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/7/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import CoreGraphics

protocol AddTaskListTableViewControllerDelegate: class {
  func addTaskListTableViewController(_ controller: AddTaskListTableViewController, keyboardWillShow show: Bool, with height: CGFloat)
  func addTaskListTableViewController(_ controller: AddTaskListTableViewController, didEnableButton enable: Bool)
}

class AddTaskListTableViewController: UITableViewController {
  
  @IBOutlet private weak var colorPickerView: UICollectionView!
  @IBOutlet private weak var iconPickerView: UICollectionView!
  @IBOutlet private weak var listNameTextField: UITextField!
  
  private let colors = UIColor.ColorPicker.all
  private let icons = CategoryIcon.all
  
  weak var delegate: AddTaskListTableViewControllerDelegate?
  var selectedColor = UIColor.ColorPicker.americanRiver
  var selectedIcon: CategoryIcon = .bam
  var listNameText: String!

  override func viewDidLoad() {
    super.viewDidLoad()
    registerNibs()
    delegate?.addTaskListTableViewController(self, didEnableButton: false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
  
  //MARK: - getKeyboardHeight method
  @objc func adjustForKeyboard(notification: Notification) {
    let userInfo:NSDictionary = notification.userInfo! as NSDictionary
    let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
    let keyboardRectangle = keyboardFrame.cgRectValue
    let keyboardHeight = keyboardRectangle.height
    
    if notification.name.rawValue == "UIKeyboardWillHideNotification" {
      delegate?.addTaskListTableViewController(self, keyboardWillShow: false, with: keyboardHeight)
    } else {
      delegate?.addTaskListTableViewController(self, keyboardWillShow: true, with: keyboardHeight)
    }
  }
  
  //MARK: - Private methods
  private func registerNibs() {
    let colorPickerCellNib = UINib(nibName: "ColorPickerCollectionCell", bundle: nil)
    colorPickerView.register(colorPickerCellNib, forCellWithReuseIdentifier: ColorPickerCollectionCell.reusableId)
    
    let iconPickerCellNib = UINib(nibName: "IconPickerCollectionCell", bundle: nil)
    iconPickerView.register(iconPickerCellNib, forCellWithReuseIdentifier: IconPickerCollectionCell.reusableId)
  }
  
  private func didSelectColor(at indexPath: IndexPath) {
    selectedColor = colors[indexPath.row]
    colorPickerView.reloadData()
    iconPickerView.reloadData()
  }
  
  private func didSelectIcon(at indexPath: IndexPath) {
    selectedIcon = icons[indexPath.row]
    iconPickerView.reloadData()
  }
}

//MARK: - UICollection delegate methods
extension AddTaskListTableViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    listNameTextField.resignFirstResponder()
    
    if collectionView === colorPickerView {
      didSelectColor(at: indexPath)
    } else {
      didSelectIcon(at: indexPath)
    }
  }
}

//MARK: - UICollection dataSource methods
extension AddTaskListTableViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView === colorPickerView {
      return colors.count
    } else {
      return icons.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView === colorPickerView {
      let cell = colorPickerView.dequeueReusableCell(withReuseIdentifier: ColorPickerCollectionCell.reusableId, for: indexPath) as! ColorPickerCollectionCell
      let color = colors[indexPath.row]
      cell.configure(withColor: color, isSelected: color == selectedColor)
      return cell
    } else {
      let cell = iconPickerView.dequeueReusableCell(withReuseIdentifier: IconPickerCollectionCell.reusableId, for: indexPath) as! IconPickerCollectionCell
      let icon = icons[indexPath.row]
      cell.configure(withIcon: icon, isSelected: icon == selectedIcon, color: selectedColor)
      return cell
    }
  }
}

extension AddTaskListTableViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in:oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    listNameText = newText
    delegate?.addTaskListTableViewController(self, didEnableButton: !listNameText.isEmpty)

    return true
  }
}

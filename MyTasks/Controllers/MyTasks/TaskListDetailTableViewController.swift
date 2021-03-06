//
//  TaskListDetailTableViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/7/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import CoreGraphics

protocol FormWithButtonDelegate: class {
  func formWithButtonDelegate(_ controller: UIViewController, keyboardWillShow show: Bool, with height: CGFloat)
  func formWithButtonDelegate(_ controller: UIViewController, didEnableButton enable: Bool)
}

protocol TaskListDetailTableViewControllerDelegate: class {
  func taskListDetailTableViewController(_ controller: TaskListDetailTableViewController, keyboardWillShow show: Bool, with height: CGFloat)
  func taskListDetailTableViewController(_ controller: TaskListDetailTableViewController, didEnableButton enable: Bool)
}

class TaskListDetailTableViewController: UITableViewController {
  @IBOutlet private weak var colorPickerView: UICollectionView!
  @IBOutlet private weak var listColorLabel: UILabel!
  @IBOutlet private weak var iconPickerView: UICollectionView!
  @IBOutlet private weak var listIconLabel: UILabel!
  @IBOutlet private weak var listNameTextField: UITextField!
  @IBOutlet private weak var listNameLabel: UILabel!
  private let colors = UIColor.ColorPicker.all
  private let icons = CategoryIcon.all
  var selectedColor = UIColor.ColorPicker.americanRiver
  var selectedIcon: CategoryIcon = .bam
  var listNameText: String!
  var tasklistToEdit: Tasklist?
  weak var delegate: TaskListDetailTableViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let tasklistToEdit = tasklistToEdit {
      selectedIcon = tasklistToEdit.icon
      selectedColor = tasklistToEdit.color
      listNameText = tasklistToEdit.name
      listNameTextField.text = listNameText
    }
    registerNibs()
    updateUILabels()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  // MARK: - getKeyboardHeight method
  @objc func adjustForKeyboard(notification: Notification) {
    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
    let keyboardFrame: NSValue = (userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue)!
    let keyboardRectangle = keyboardFrame.cgRectValue
    let keyboardHeight = keyboardRectangle.height
    if notification.name.rawValue == "UIKeyboardWillHideNotification" {
      delegate?.taskListDetailTableViewController(self, keyboardWillShow: false, with: keyboardHeight)
    } else {
      delegate?.taskListDetailTableViewController(self, keyboardWillShow: true, with: keyboardHeight)
    }
  }
  // MARK: - Private methods
  private func registerNibs() {
    colorPickerView.register(UINib(nibName: ColorPickerCollectionCell.reusableId, bundle: nil),
                             forCellWithReuseIdentifier: ColorPickerCollectionCell.reusableId)
    iconPickerView.register(UINib(nibName: IconPickerCollectionCell.reusableId, bundle: nil),
                            forCellWithReuseIdentifier: IconPickerCollectionCell.reusableId)
  }
  private func updateUILabels() {
    listNameLabel.text = "list_name".localized
    listColorLabel.text = "list_color".localized
    listIconLabel.text = "list_icon".localized
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
}

// MARK: - UICollection delegate methods
extension TaskListDetailTableViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    listNameTextField.resignFirstResponder()
    switch collectionView {
    case colorPickerView:
      didSelectColor(at: indexPath)
    default:
      didSelectIcon(at: indexPath)
    }
  }
}
// MARK: - UICollection dataSource methods
extension TaskListDetailTableViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case colorPickerView:
      return colors.count
    default:
      return icons.count
    }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {
    case colorPickerView:
      let cell = (colorPickerView.dequeueReusableCell(withReuseIdentifier: ColorPickerCollectionCell.reusableId, for: indexPath) as? ColorPickerCollectionCell)!
      let color = colors[indexPath.row]
      cell.configure(withColor: color, isSelected: color == selectedColor)
      return cell
    default:
      let cell = (iconPickerView.dequeueReusableCell(withReuseIdentifier: IconPickerCollectionCell.reusableId, for: indexPath) as? IconPickerCollectionCell)!
      let icon = icons[indexPath.row]
      cell.configure(withIcon: icon, isSelected: icon == selectedIcon, color: selectedColor)
      return cell
    }
  }
}

extension TaskListDetailTableViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in: oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    listNameText = newText
    delegate?.taskListDetailTableViewController(self, didEnableButton: !listNameText.isEmpty)
    return true
  }
}

//
//  AddTaskListViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class AddTaskListViewController: UIViewController {
  
  @IBOutlet weak var mainActionButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddTaskListTable" {
      let controller = segue.destination as! AddTaskListTableViewController
      controller.delegate = self
    }
  }
  
  private func adjustForKeyboard(show: Bool, height: CGFloat) {
    let height = show ? view.frame.height - height : view.frame.height + height
    print(height)
    let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: height)
    view.frame = frame
  }
}

extension AddTaskListViewController: AddTaskListTableViewControllerDelegate {
  func addTaskListTableViewController(_ controller: AddTaskListTableViewController, keyboardWillShow show: Bool, withHeight height: CGFloat) {
    adjustForKeyboard(show: show, height: height)
  }
}

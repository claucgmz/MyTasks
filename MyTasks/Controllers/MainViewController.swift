//
//  MainViewController.swift
//  MyTasks
//
//  Created by Caludia Carrillo on 2/6/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  @IBOutlet private weak var userProfileImage: UIImageView!
  @IBOutlet private weak var welcomeLabel: UILabel!
  @IBOutlet private weak var todaySummaryLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  
  var lists = ["List 1" , "List 2", "List 3",  "List 2", "List 3"]
  var listCollectionCellId = "ListCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUserLabels()
  }
  
  private func updateUserLabels() {
    
  }
  
}

extension MainViewController: UICollectionViewDelegate {
  
}

extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return lists.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCollectionCellId, for: indexPath)
    
    return cell
  }
}

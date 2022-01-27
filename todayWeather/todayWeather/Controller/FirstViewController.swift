//
//  ViewController.swift
//  todayWeather
//
//  Created by 임영선 on 2022/01/26.
//

import UIKit

class FirstViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!
  
  let customCellIdentifer: String = "customCell"
  let cellSpacingHeight: CGFloat = 5
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
   
    tableView.dataSource = self
    tableView.delegate = self
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FirstViewController: UITableViewDataSource, UITableViewDelegate {
  
  // cell에 space를 넣기 위해 데이터 개수만큼 section을 생성하고 row는 1개 리턴
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellIdentifer, for: indexPath)
            as? CustomTableViewCell else { return UITableViewCell() }
    let index = indexPath.section
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.0
  }
  
}


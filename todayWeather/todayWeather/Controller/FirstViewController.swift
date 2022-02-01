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
  var weatherViewModel: WeatherViewModel?
  let citieNames = ["Gongju", "Gwangju", "Gumi", "Gunsan", "Daegu", "Daejeon", "Mokpo", "Busan", "Seosan", "Seoul", "Sokcho", "Suwon", "Suncheon", "Ulsan", "Iksan", "Jeonju", "Jeju", "Cheonan", "Cheongju", "Chuncheon"]

  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
   
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let nextVC: SecondViewController = segue.destination as? SecondViewController else { return }
    guard let cell: CustomTableViewCell = sender as? CustomTableViewCell else { return }
    nextVC.selectedIndex = cell.selectIndex
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FirstViewController: UITableViewDataSource, UITableViewDelegate {
  
  // cell에 space를 넣기 위해 데이터 개수만큼 section을 생성하고 row는 1개 리턴
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.citieNames.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellIdentifer, for: indexPath)
            as? CustomTableViewCell else { return UITableViewCell() }
    
    cell.selectionStyle = .none
    
    let index = indexPath.section
    cell.selectIndex = index
    cell.cityNameLabel.text = citieNames[index]
    WeatherSurvice().getWeather(cityName: citieNames[index], completion: { result in
      switch result {
      case .success(let result):
        DispatchQueue.main.async {
          self.weatherViewModel = WeatherViewModel(weatherModel: result)
          cell.humidityLabel.text = self.weatherViewModel?.humidity
          cell.tempLabel.text = self.weatherViewModel?.celsiusTemp
          cell.weatherImageView.image = UIImage(named: self.weatherViewModel?.weatherImageName ?? "")
        }
      case .failure(_ ):
        print("error")
      }
    })
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.0
  }
  
}


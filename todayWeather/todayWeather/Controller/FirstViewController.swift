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
  @IBOutlet weak var tempButton: UIButton!
  
  let customCellIdentifer: String = "customCell"
  let cellSpacingHeight: CGFloat = 5
  var weatherViewModel: WeatherViewModel?
  let citieNames = ["Gongju", "Gwangju", "Gumi", "Gunsan", "Daegu", "Daejeon", "Mokpo", "Busan", "Seosan", "Seoul", "Sokcho", "Suwon", "Suncheon", "Ulsan", "Iksan", "Jeonju", "Jeju", "Cheonan", "Cheongju", "Chuncheon"]
  var tempMode = TempMode.celsius
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tempButton.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
  }
  
  // MARK: - Methods
  @objc func didTabButton(_ sender: UIButton) {
    switch tempMode {
    case .fahrenheit:
      tempMode = .celsius
      tableView.reloadData()
    case .celsius:
      tempMode = .fahrenheit
      tableView.reloadData()
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let nextVC: SecondViewController = segue.destination as? SecondViewController else { return }
    guard let cell: CustomTableViewCell = sender as? CustomTableViewCell else { return }
    nextVC.selectedIndex = cell.selectIndex // 선택한 cell의 index 다음 VC에 넘김
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
    cell.selectionStyle = .none // 선택 스타일 none
    let index = indexPath.section
    cell.selectIndex = index
    cell.cityNameLabel.text = citieNames[index]
    WeatherSurvice().getWeather(cityName: citieNames[index], completion: { result in
      switch result {
      case .success(let result):
        DispatchQueue.main.async {
          self.weatherViewModel = WeatherViewModel(weatherModel: result)
          cell.humidityLabel.text = self.weatherViewModel?.humidity
          cell.weatherImageView.image = UIImage(named: self.weatherViewModel?.weatherImageName ?? "")
          
          switch self.tempMode { // tempMode에 따라 온도 바꿈
          case .fahrenheit:
            cell.tempLabel.text = self.weatherViewModel?.fahrenheitTemp
          case .celsius:
            cell.tempLabel.text = self.weatherViewModel?.celsiusTemp
          }
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


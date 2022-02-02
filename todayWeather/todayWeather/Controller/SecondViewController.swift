//
//  SecondViewController.swift
//  todayWeather
//
//  Created by 임영선 on 2022/02/01.
//

import UIKit

class SecondViewController: UIViewController {
  
  // MARK: - Properties
  let citieNames = ["Gongju", "Gwangju", "Gumi", "Gunsan", "Daegu", "Daejeon", "Mokpo", "Busan", "Seosan", "Seoul", "Sokcho", "Suwon", "Suncheon", "Ulsan", "Iksan", "Jeonju", "Jeju", "Cheonan", "Cheongju", "Chuncheon"]
  var selectedIndex: Int?
  var weatherViewModel: WeatherViewModel?
  var tempMode: TempMode = .celsius
  
  @IBOutlet weak var tempView: UIView!
  @IBOutlet weak var etcView: UIView!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var weatherLabel: UILabel!
  @IBOutlet weak var weatherImageView: UIImageView!
  @IBOutlet weak var tempLabel: UILabel!
  @IBOutlet weak var feelLikeTempLabel: UILabel!
  @IBOutlet weak var maxTempLabel: UILabel!
  @IBOutlet weak var minTempLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var pressureLabel: UILabel!
  @IBOutlet weak var windLabel: UILabel!
  @IBOutlet weak var tempButton: UIButton!
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.tintColor = .black // navigationButton 검정으로 변경
    tempView.layer.cornerRadius = 20.0
    etcView.layer.cornerRadius = 20.0
    tempButton.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
    setData()
  }
    
  // MARK - Methods
  @objc func didTabButton(_ sender: UIButton) {
    switch tempMode {
    case .fahrenheit:
      tempMode = .celsius
      setData()
    case .celsius:
      tempMode = .fahrenheit
      setData()
    }
  }
  func setData() {
    guard let selectedIndex = selectedIndex else {
      return
    }
    WeatherSurvice().getWeather(cityName: citieNames[selectedIndex], completion: { result in
      switch result {
      case .success(let result):
        DispatchQueue.main.async {
          self.weatherViewModel = WeatherViewModel(weatherModel: result)
          self.cityLabel.text = self.citieNames[selectedIndex]
          self.weatherLabel.text = self.weatherViewModel?.weather
          self.humidityLabel.text = self.weatherViewModel?.humidity
          self.pressureLabel.text = self.weatherViewModel?.pressure
          self.windLabel.text = self.weatherViewModel?.wind
          self.weatherImageView.image = UIImage(named: self.weatherViewModel?.weatherImageName ?? "")
          
          switch self.tempMode { // tempMode에 따라 온도 text 바꿈
          case .celsius:
            self.tempLabel.text = self.weatherViewModel?.celsiusTemp
            self.feelLikeTempLabel.text = self.weatherViewModel?.feelsLikeCelsiusTemp
            self.minTempLabel.text = self.weatherViewModel?.minCelsiusTemp
            self.maxTempLabel.text = self.weatherViewModel?.maxCelsiusTemp
            
          case .fahrenheit:
            self.tempLabel.text = self.weatherViewModel?.fahrenheitTemp
            self.feelLikeTempLabel.text = self.weatherViewModel?.feelsLikeFahrenheitTemp
            self.minTempLabel.text = self.weatherViewModel?.minFahrenheitTemp
            self.maxTempLabel.text = self.weatherViewModel?.maxFahrenheitTemp
          }
        }
      case .failure(_ ):
        print("error")
      }
    })
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let nextVC: ThirdViewController = segue.destination as? ThirdViewController else { return }
    nextVC.selectedIndex = self.selectedIndex // 선택한 cell의 인덱스 다음 VC에 넘김
  }
}

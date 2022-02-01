//
//  SecondViewController.swift
//  todayWeather
//
//  Created by 임영선 on 2022/02/01.
//

import UIKit

class SecondViewController: UIViewController {
  
  let citieNames = ["Gongju", "Gwangju", "Gumi", "Gunsan", "Daegu", "Daejeon", "Mokpo", "Busan", "Seosan", "Seoul", "Sokcho", "Suwon", "Suncheon", "Ulsan", "Iksan", "Jeonju", "Jeju", "Cheonan", "Cheongju", "Chuncheon"]
  var selectedIndex: Int?
  var weatherViewModel: WeatherViewModel?
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tempView.layer.cornerRadius = 20.0
    etcView.layer.cornerRadius = 20.0
    setData()
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
          
          self.tempLabel.text = self.weatherViewModel?.celsiusTemp
          self.feelLikeTempLabel.text = self.weatherViewModel?.feelsLikeCelsiusTemp
          self.minTempLabel.text = self.weatherViewModel?.minCelsiusTemp
          self.maxTempLabel.text = self.weatherViewModel?.maxCelsiusTemp
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

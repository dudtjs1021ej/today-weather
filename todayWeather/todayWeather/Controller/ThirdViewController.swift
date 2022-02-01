//
//  ThirdViewController.swift
//  todayWeather
//
//  Created by 임영선 on 2022/02/01.
//

import UIKit

class ThirdViewController: UIViewController {
  // MARK: - Properties
  var selectedIndex: Int?
  let citieNames = ["Gongju", "Gwangju", "Gumi", "Gunsan", "Daegu", "Daejeon", "Mokpo", "Busan", "Seosan", "Seoul", "Sokcho", "Suwon", "Suncheon", "Ulsan", "Iksan", "Jeonju", "Jeju", "Cheonan", "Cheongju", "Chuncheon"]
  var viewModel: ForecastWeatherViewModel?
  
  @IBOutlet weak var humidityGraphView: UIView!
  @IBOutlet weak var humidityView: UIView!
  @IBOutlet weak var humidityDateLabel: UILabel!
  @IBOutlet weak var maxTemperatureView: UIView!
  @IBOutlet weak var maxTemperatureGraphView: UIView!
  @IBOutlet weak var maxTemperatureDateLabel: UILabel!
  @IBOutlet weak var minTemperatureView: UIView!
  @IBOutlet weak var minTemperatureGraphView: UIView!
  @IBOutlet weak var minTemperatureDateLabel: UILabel!
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setData()
    humidityView.layer.cornerRadius = 20.0
    maxTemperatureView.layer.cornerRadius = 20.0
    minTemperatureView.layer.cornerRadius = 20.0
    
    NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil) // 회전감지 NotificationCenter
  }
  
  // MARK: - Methods
  // 기기가 회전될 때마다 다시 그래프 그림
  @objc func rotated() {
    if UIDevice.current.orientation.isLandscape {
      setData()
    }
    if UIDevice.current.orientation.isPortrait {
      setData()
    }
  }
  
  func setData() {
    guard let selectedIndex = selectedIndex else { return }
    WeatherSurvice().getForecastWeather(cityName: citieNames[selectedIndex], completion: { result in
      switch result {
      case .success(let result):
        DispatchQueue.main.async {
          self.viewModel = ForecastWeatherViewModel(model: result)
          let date = self.viewModel?.dateLabelText
          self.humidityDateLabel.text = date
          self.maxTemperatureDateLabel.text = date
          self.minTemperatureDateLabel.text = date
          // 그래프 draw
          self.viewModel?.drawGraph(graphType: GraphType.humidity, view: self.humidityGraphView)
          self.viewModel?.drawGraph(graphType: GraphType.minTemp, view: self.minTemperatureGraphView)
          self.viewModel?.drawGraph(graphType: GraphType.maxTemp, view: self.maxTemperatureGraphView)
        }
      case .failure(_ ):
        print("error")
      }
    })
  }
}

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
  var tempMode: TempMode = .celsius
  
  @IBOutlet weak var humidityGraphView: UIView!
  @IBOutlet weak var humidityView: UIView!
  @IBOutlet weak var humidityDateLabel: UILabel!
  @IBOutlet weak var maxTemperatureView: UIView!
  @IBOutlet weak var maxTemperatureGraphView: UIView!
  @IBOutlet weak var maxTemperatureDateLabel: UILabel!
  @IBOutlet weak var minTemperatureView: UIView!
  @IBOutlet weak var minTemperatureGraphView: UIView!
  @IBOutlet weak var minTemperatureDateLabel: UILabel!
  @IBOutlet weak var tempButton: UIButton!
  @IBOutlet var maxTempLabels: Array<UILabel>!
  @IBOutlet var minTempLabels: Array<UILabel>!
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setData()
    humidityView.layer.cornerRadius = 20.0
    maxTemperatureView.layer.cornerRadius = 20.0
    minTemperatureView.layer.cornerRadius = 20.0
    tempButton.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
    NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil) // 회전감지 NotificationCenter
  }
  
  // MARK: - Methods
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
    // tempMode에 따라 온도 범위 텍스트 바꿈
    switch tempMode {
    case .fahrenheit:
      var temp = 40
      for i in 0..<minTempLabels.count {
        maxTempLabels[i].text = "\(temp)℉"
        minTempLabels[i].text = "\(temp)℉"
        temp -= 40
      }
      
    case .celsius:
      var temp = 30
      for i in 0..<minTempLabels.count {
        maxTempLabels[i].text = "\(temp)℃"
        minTempLabels[i].text = "\(temp)℃"
        temp -= 30
      }
    }
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
          self.viewModel?.drawGraph(graphType: GraphType.humidity, view: self.humidityGraphView, tempMode: self.tempMode)
          self.viewModel?.drawGraph(graphType: GraphType.minTemp, view: self.minTemperatureGraphView, tempMode: self.tempMode)
          self.viewModel?.drawGraph(graphType: GraphType.maxTemp, view: self.maxTemperatureGraphView, tempMode: self.tempMode)
        }
      case .failure(_ ):
        print("error")
      }
    })
  }
}

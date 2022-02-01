//
//  ThirdViewController.swift
//  todayWeather
//
//  Created by 임영선 on 2022/02/01.
//

import UIKit

class ThirdViewController: UIViewController {
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setData()
    
    humidityView.layer.cornerRadius = 20.0
    maxTemperatureView.layer.cornerRadius = 20.0
    minTemperatureView.layer.cornerRadius = 20.0
  }
  
  func setData() {
    guard let selectedIndex = selectedIndex else {
      return
    }

    WeatherSurvice().getForecastWeather(cityName: citieNames[selectedIndex], completion: { result in
      switch result {
      case .success(let result):
        DispatchQueue.main.async {
          self.viewModel = ForecastWeatherViewModel(model: result)
          let date = self.viewModel?.dateLabelText
          self.humidityDateLabel.text = date
          self.maxTemperatureDateLabel.text = date
          self.minTemperatureDateLabel.text = date
//          print("humidity:\(self.viewModel?.humidities)")
//          print("maxTemps:\(self.viewModel?.maxTemps)")
//          print("minTemps:\(self.viewModel?.minTemps)")
//          print("times:\(self.viewModel?.times)")
          self.viewModel?.drawGraph(graphType: GraphType.humidity, view: self.humidityGraphView)
          self.viewModel?.drawGraph(graphType: GraphType.minTemp, view: self.minTemperatureGraphView)
          self.viewModel?.drawGraph(graphType: GraphType.maxTemp, view: self.maxTemperatureGraphView)
          //self.viewModel?.drawGraph(view: self.humidityGraphView)
          //self.viewModel?.drawYValue(view: self.humidityValueView)
          //self.viewModel?.drawTimeText(view: self.humidityTimeView)
         
        }
      case .failure(_ ):
        print("error")
      }
    })
  }

}

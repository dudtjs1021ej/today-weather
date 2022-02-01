//
//  WeatherViewModel.swift
//  todayWeather
//
//  Created by 임영선 on 2022/01/31.
//

import Foundation
class WeatherViewModel {
  let weatherModel: WeatherModel
  
  init(weatherModel: WeatherModel) {
    self.weatherModel = weatherModel
  }
  
  var humidity: String {
    return String("\(weatherModel.main.humidity)%")
  }
  
  var fahrenheit: String {
    var fahrenheit = round((weatherModel.main.temp - 273.15) * 1.8 + 32.0)
    if fahrenheit == -0.0 {
      fahrenheit = 0.0
    }
    return String("\(fahrenheit)%")
  }
  
  var celsius: String {
    var celsius = round(weatherModel.main.temp - 273.15)
    if celsius == -0.0 {
      celsius = 0.0
    }
    return String("\(celsius)℃")
  }
  
  var weatherImageName: String {
    return String(weatherModel.weather.first?.main ?? "")
  }
}

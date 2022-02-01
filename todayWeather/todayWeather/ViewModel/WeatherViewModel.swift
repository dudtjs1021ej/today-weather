//
//  WeatherViewModel.swift
//  todayWeather
//
//  Created by 임영선 on 2022/01/31.
//

import Foundation

// 섭씨 화씨 계산 열거형
enum Temp {
  case fahrenheit(Double)
  case celsius(Double)
  
  var temp: Double {
    switch self {
    case let .celsius(value):
      return round(value - 273.15) == -0.0 ? 0.0 : round(value - 273.15) // 반올림해서 -0.0 인경우 0.0으로 변경
      
    case let .fahrenheit(value):
      return round((value - 273.15) * 1.8 + 32.0) == -0.0 ? 0.0 : round((value - 273.15) * 1.8 + 32.0) // 반올림해서 -0.0 인경우 0.0으로 변경
    }
  }
}

class WeatherViewModel {
  let weatherModel: WeatherModel
  
  init(weatherModel: WeatherModel) {
    self.weatherModel = weatherModel
  }
  
  var humidity: String {
    return String("\(weatherModel.main.humidity)%")
  }
  
  var pressure: String {
    return String("\(weatherModel.main.pressure)hPa")
  }
  
  var wind: String {
    return String("\(weatherModel.wind.speed)m/s")
  }
  
  var weather: String {
    guard let weather = weatherModel.weather.first?.main else { return ""}
    return String("\(weather) weather")
  }
  
  // 섭씨 온도
  var celsiusTemp: String {
    let celsius = Temp.celsius(weatherModel.main.temp).temp
    return String("\(celsius)℃")
  }
  
  var feelsLikeCelsiusTemp: String {
    let celsius = Temp.celsius(weatherModel.main.feels_like).temp
    return String("\(celsius)℃")
  }
  
  var minCelsiusTemp: String {
    let celsius = Temp.celsius(weatherModel.main.temp_min).temp
    return String("\(celsius)℃")
  }
  
  var maxCelsiusTemp: String {
    let celsius = Temp.celsius(weatherModel.main.temp_max).temp
    return String("\(celsius)℃")
  }
  
  // 화씨 온도
  var fahrenheitTemp: String {
    let fahrenheit = Temp.fahrenheit(weatherModel.main.temp).temp
    return String("\(fahrenheit)%")
  }
  
  var feelsLikeFahrenheitTemp: String {
    let fahrenheit = Temp.fahrenheit(weatherModel.main.feels_like).temp
    return String("\(fahrenheit)%")
  }
  
  var minFahrenheitTemp: String {
    let fahrenheit = Temp.fahrenheit(weatherModel.main.temp_min).temp
    return String("\(fahrenheit)%")
  }
  
  var maxFahrenheitTemp: String {
    let fahrenheit = Temp.fahrenheit(weatherModel.main.temp_max).temp
    return String("\(fahrenheit)%")
  }
  
  
  var weatherImageName: String {
    return String(weatherModel.weather.first?.main ?? "")
  }
}

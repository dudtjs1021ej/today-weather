//
//  Weather.swift
//  todayWeather
//
//  Created by 임영선 on 2022/01/29.
//

import Foundation

struct WeatherModel: Codable {
  let weather: [Weather]
  let main: Main
}

struct Main: Codable {
  let temp: Double
  let humidity: Double
}

struct Weather: Codable {
  let id: Int
  let main: String
  let icon: String
}

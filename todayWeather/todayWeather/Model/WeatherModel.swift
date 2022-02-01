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
  let wind: Wind
}

struct Main: Codable {
  let temp: Double
  let feels_like: Double
  let temp_min: Double
  let temp_max: Double
  let humidity: Double
  let pressure: Double
}

struct Weather: Codable {
  let id: Int
  let main: String
  let icon: String
}

struct Wind: Codable {
  let speed: Double
}

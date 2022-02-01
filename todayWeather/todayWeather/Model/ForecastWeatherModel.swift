//
//  ForecastWeatherModel.swift
//  todayWeather
//
//  Created by 임영선 on 2022/02/01.
//

import Foundation

struct ForecastWeatherModel: Codable {
  let list: [List]
}

struct List: Codable {
  let main: Main
  let dt_txt: String
}

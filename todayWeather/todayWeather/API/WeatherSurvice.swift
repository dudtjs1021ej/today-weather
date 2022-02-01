//
//  WeatherSurvice.swift
//  todayWeather
//
//  Created by 임영선 on 2022/01/29.
//

import Foundation

enum NetworkError: Error {
  case badURL
  case noData
  case decodingError
}

class WeatherSurvice {
  
  private var apiKey = Storage().apiKey
  var weatherModel: WeatherModel?
  
  func getWeather(cityName: String, completion: @escaping (Result<WeatherModel, NetworkError>) -> Void ) {
      guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)") else {
        return completion(.failure(.badURL))
      }
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      let session = URLSession(configuration: .default)
      let dataTask = session.dataTask(with: request) { (data, response, error) in
        guard let data = data else {
          return completion(.failure(.noData))
        }
        do {
          let result = try JSONDecoder().decode(WeatherModel.self, from: data)
          DispatchQueue.main.async {
            completion(.success(result))
          }

        } catch {
          completion(.failure(.decodingError))
        }
      }
      dataTask.resume()
    }
  
  func getForecastWeather(cityName: String, completion: @escaping (Result<ForecastWeatherModel, NetworkError>) -> Void ) {
    guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(apiKey)") else {
      return completion(.failure(.badURL))
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    let session = URLSession(configuration: .default)
    let dataTask = session.dataTask(with: request) { (data, response, error) in
      guard let data = data else {
        return completion(.failure(.noData))
      }
      do {
        let result = try JSONDecoder().decode(ForecastWeatherModel.self, from: data)
        DispatchQueue.main.async {
          completion(.success(result))
        }
      } catch {
        completion(.failure(.decodingError))
      }
    }
    dataTask.resume()
  }
}

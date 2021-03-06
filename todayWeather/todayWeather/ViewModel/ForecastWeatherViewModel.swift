//
//  ForecastWeatherViewModel.swift
//  todayWeather
//
//  Created by 임영선 on 2022/02/01.
//

import Foundation
import UIKit

// MARK: - GrapType
enum GraphType {
  case humidity
  case maxTemp
  case minTemp
}

// MARK: - ForecastWeatherViewModel
class ForecastWeatherViewModel {
  let model: ForecastWeatherModel
  
  init(model: ForecastWeatherModel) {
    self.model = model
  }
  // MARK: - Properties
  var humidities: [Double] {
    var humidities: [Double] = []
    for i in 0..<model.list.count {
      humidities.append(model.list[i].main.humidity)
    }
    return humidities
  }
  
  var maxCelsiusTemps: [Double] {
    var maxTemps: [Double] = []
    for i in 0..<model.list.count {
      let maxTemp = Temp.celsius(model.list[i].main.temp_max).temp
      maxTemps.append(maxTemp)
    }
    return maxTemps
  }
  
  var minCelsiusTemps: [Double] {
    var minTemps: [Double] = []
    for i in 0..<model.list.count {
      let minTemp = Temp.celsius(model.list[i].main.temp_min).temp
      minTemps.append(minTemp)
    }
    return minTemps
  }
  
  var maxFahrenhietTemps: [Double] {
    var maxTemps: [Double] = []
    for i in 0..<model.list.count {
      let maxTemp = Temp.fahrenheit(model.list[i].main.temp_max).temp
      maxTemps.append(maxTemp)
    }
    return maxTemps
  }
  
  var minFahrenheitTemps: [Double] {
    var minTemps: [Double] = []
    for i in 0..<model.list.count {
      let minTemp = Temp.fahrenheit(model.list[i].main.temp_min).temp
      minTemps.append(minTemp)
    }
    return minTemps
  }
  
  var times: [String] {
    var times: [String] = []
    for i in 0..<model.list.count {
      let time = model.list[i].dt_txt
      times.append(time)
    }
    return times
  }
  
  var dateLabelText: String {
    return "\(times.first ?? "") ~ \(times.last ?? "")"
  }
  
  // MARK: - Methods
  // view의 크기에 맞게 계산하여 이중 배열로 x,y 좌표들 리턴
  func getPoints(graphType: GraphType, view: UIView, tempMode: TempMode) -> [[Double]] {
    let xSpace = Double(Int(view.frame.width) / (self.humidities.count)) // x 좌표 한 칸 값
    var xPoints: [Double] = []
    var x: Double = 0.0
    for _ in 0..<self.humidities.count {
      xPoints.append(x + xSpace)
      x += xSpace
    }
    
    // 그래프타입에 따라 y좌표 다르게 계산
    switch graphType {
    case .humidity:
      let ySpace = Double(Int(view.frame.height) / 100 ) // y 좌표 한 칸 값 (humidity는 0~100%)
      var yPoints: [Double] = []
      for i in 0..<self.humidities.count {
        yPoints.append((view.frame.height) - (self.humidities[i] * ySpace))
      }
      let points = [xPoints, yPoints]
      return points
      
    case .maxTemp:
      var yPoints: [Double] = []
      switch tempMode { // tempMode에 따라 좌표 다르게 계산
      case .fahrenheit:
        let ySpace = Double(Int(view.frame.height) / 80 ) // y 좌표 한 칸 값 (temp는 -40~40℉)
        for i in 0..<self.maxFahrenhietTemps.count {
          yPoints.append((view.frame.height) - (self.maxFahrenhietTemps[i] * ySpace + (Double(view.frame.height) / 2)))
        }
      case .celsius:
        let ySpace = Double(Int(view.frame.height) / 60 ) // y 좌표 한 칸 값 (temp는 -30~30℃)
        for i in 0..<self.maxCelsiusTemps.count {
          yPoints.append((view.frame.height) - (self.maxCelsiusTemps[i] * ySpace + (Double(view.frame.height) / 2)))
        }
      }
      let points = [xPoints, yPoints]
      return points
      
    case .minTemp:
      var yPoints: [Double] = []
      switch tempMode {
      case .fahrenheit:
        let ySpace = Double(Int(view.frame.height) / 80 )
        for i in 0..<self.minFahrenheitTemps.count {
          yPoints.append((view.frame.height) - (self.minFahrenheitTemps[i] * ySpace + (Double(view.frame.height) / 2)))
        }
      case .celsius:
        let ySpace = Double(Int(view.frame.height) / 60 )
        for i in 0..<self.minCelsiusTemps.count {
          yPoints.append((view.frame.height) - (self.minCelsiusTemps[i] * ySpace + (Double(view.frame.height) / 2)))
        }
      }
      let points = [xPoints, yPoints]
      return points
    }
  }
  
  // 그래프 그리기
  func drawGraph(graphType: GraphType, view: UIView, tempMode: TempMode) {
    view.layer.sublayers = nil // 회전 시 그려진 그래프 다 지우고 시작
    drawBackgroundLine(view: view, color: UIColor.darkGray.cgColor) // 배경선 draw
    let points = getPoints(graphType: graphType, view: view, tempMode: tempMode) // 그리는 그래프 타입에 따라 x,y좌표 다르게 받아옴
    let layer = CAShapeLayer()
    let path = UIBezierPath()
    layer.fillColor = UIColor.clear.cgColor // 채우기 취소
    path.move(to: CGPoint(x: points[0][0], y: points[1][0]))
    for i in 1..<self.times.count {
      path.addLine(to: CGPoint(x: points[0][i], y: points[1][i]))
    }
    layer.path = path.cgPath
    
    // 그래프타입에 따라 선 컬러 다르게 설정
    switch graphType {
    case .humidity:
      layer.strokeColor = UIColor.black.cgColor
    case .maxTemp:
      layer.strokeColor = UIColor.systemRed.cgColor
    case .minTemp:
      layer.strokeColor = UIColor.systemBlue.cgColor
    }
    layer.lineWidth = 3
    layer.lineCap = .round
    layer.lineJoin = .round
    view.layer.addSublayer(layer)
  }
  
  // 그래프 배경선 그리기
  func drawBackgroundLine(view: UIView, color: CGColor) {
    let layer = CAShapeLayer()
    let path = UIBezierPath()
    layer.fillColor = UIColor.clear.cgColor // 채우기 취소
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: 0, y: view.frame.height))
    path.addLine(to: CGPoint(x: view.frame.width, y: view.frame.height))
    layer.path = path.cgPath
    layer.strokeColor = color
    layer.lineWidth = 3
    layer.lineCap = .round // 둥글게
    layer.lineJoin = .round
    view.layer.addSublayer(layer)
  }
  
  //  func drawXVlaue(view: UIView) {
  //    let points = getPoints(graphType: .humidity, view: view)
  //
  //    for i in 0..<humidities.count {
  //      let label = UILabel()
  //      label.font = UIFont(name: "Helvetica-Bold", size: 5)
  //      label.frame = CGRect(x: points[0][i], y: 5, width: 10, height: 70)
  //      label.text = self.times[i]
  //      label.textColor = .darkGray
  //      label.isHidden = false
  //      view.addSubview(label)
  //    }
  //
  //  }
  //  // y좌표 값 text로 그리기
  //  func drawYValue(view: UIView) {
  //    let points = getPoints(graphType: .humidity, view: view)
  //
  //    for i in 0..<humidities.count {
  //      let label = UILabel()
  //      label.font = UIFont(name: "Helvetica-Bold", size: 10)
  //      label.frame = CGRect(x: 0, y: points[1][i], width: view.frame.width, height: 10)
  //      label.text = String(self.humidities[i])
  //      label.textColor = .darkGray
  //      label.isHidden = false
  //      view.addSubview(label)
  //    }
  //  }
   
}

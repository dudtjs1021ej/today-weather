//
//  File.swift
//  todayWeather
//
//  Created by 임영선 on 2022/02/02.
//
import Foundation
import UIKit

extension UIFont {
  
  enum Family: String {
    case Black = "Black"
    case Bold = "Bold"
    case SemiBold = "SemiBold"
    case Light = "Light"
    case Medium = "Medium"
    case Regular = "Regular"
    case Thin = "Thin"
  }
  
  static func poppins(size: CGFloat = 10, family: Family = .Regular) -> UIFont {
    print("Poppins-\(family)")
    return UIFont(name: "Poppins-\(family)", size: size)!
  }
}

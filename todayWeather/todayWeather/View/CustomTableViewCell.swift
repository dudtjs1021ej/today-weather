//
//  CustomTableViewCell.swift
//  todayWeather
//
//  Created by 임영선 on 2022/01/27.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var tempLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var weatherImageView: UIImageView!
  var selectIndex: Int?
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
  }
  
  // 셀의 재사용으로 인한 문제 해결
  override func prepareForReuse() {
    weatherImageView.image = nil
    humidityLabel.text = nil
    tempLabel.text = nil
  }
}

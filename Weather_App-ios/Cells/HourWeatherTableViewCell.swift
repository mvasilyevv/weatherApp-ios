import UIKit

class HourWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
  static let identifier = "HourWeatherTableViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImageView.image = nil
        self.tempLabel.text = nil
        self.hourLabel.text = nil
    }
    
    func configure(day: ForecastByHourWeather)  {
        if let date = day.time {
            self.hourLabel.text = date.convertToHour()
        }
        if let temp = day.temp {
            self.tempLabel.text = temp.convertToCelsius()
        }
        if let icon = day.iconURL {
            self.iconImageView.configureIconImage(icon: icon)
        }
    }
}

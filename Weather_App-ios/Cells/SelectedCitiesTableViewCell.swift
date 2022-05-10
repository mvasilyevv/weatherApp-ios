import UIKit
import Kingfisher

class SelectedCitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    static let identifier = "SelectedCitiesTableViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityNameLabel.text = nil
        weatherImageView.image = nil
        tempLabel.text = nil
    }
    
    func configure(weather: CityWeather) {
        if let cityName = weather.city?.name {
            self.cityNameLabel.text = cityName
        }
        if let cityTemp = weather.current?.tempC {
            self.tempLabel.text = cityTemp.convertToCelsius()
        }
        if let iconURL = weather.current?.condition?.icon {
            self.weatherImageView.configureIconImage(icon: iconURL)
        }
    }
}

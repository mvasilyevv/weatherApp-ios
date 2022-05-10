import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    static let identifier = "CityTableViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cityNameLabel.text = ""
    }
    
    func configure(city: City) {
        guard let cityName = city.name else { return }
        guard let cityRegion = city.region else { return }
        guard let cityCountry = city.country else { return }
        let cityInfo = "\(cityName), \(cityRegion), \(cityCountry)"
        self.cityNameLabel.text = cityInfo
    }
}

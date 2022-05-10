import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var weatherByHourArray = [ForecastByHourWeather]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    static let identifier = "DayCollectionViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dateLabel.text = nil
    }
    
    func configure(day: ForecastByDayWeather) {
        self.dateLabel.text = day.date?.convertToData()
        if let weatherByHourArray = day.hour {
            self.weatherByHourArray = weatherByHourArray
        }
    }
}

extension DayCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherByHourArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HourWeatherTableViewCell.identifier, for: indexPath) as? HourWeatherTableViewCell else { return UITableViewCell() }
        cell.configure(day: weatherByHourArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 6
    }
}

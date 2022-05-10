import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class MainCityViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherDiscrLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLocation: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var forecastPlaceView: UIView!
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var compassPlaceView: UIView!
    
    
    // MARK: - let/var
    private let viewModel = MainCityViewModel()
    var locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    private var compassView = CompassView()
    private var loadingView = LoadingView()
    
    // MARK: - lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        getCurrentLocation()
        for view in views {
            view.rounded()
            view.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor
            view.layer.borderWidth = 1
        }
        addSwipeRecognizers()
        addPageControl()
        addCompass()
        view.addGradient(color: .day)
    }
    
    // MARK: - @IBAction
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SelectedCityViewController") as? SelectedCityViewController else { return }
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        getCurrentLocation()
    }
    @IBAction func leftSwipeDetected() {
        self.collectionView.scrollToNextItem()
        viewModel.changePage(swipeDir: .next)
    }
    @IBAction func rightSwipeDetected() {
        self.collectionView.scrollToPreviousItem()
        viewModel.changePage(swipeDir: .previous)
    }
    
    // MARK: - locationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let currentLocation = "\(location.latitude),\(location.longitude)"
        print(currentLocation)
        viewModel.sendCurrentLocationCityRequest(location: currentLocation)
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let err = error as? CLError{
            switch err {
            case CLError.locationUnknown:
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "CityListViewController") as? CityListViewController else { return }
                self.navigationController?.pushViewController(controller, animated: true)
            case CLError.denied:
                print("denied")
            case CLError.network:
                print("network")
            default:
                return
            }
        }
    }
    
    // MARK: - UI configurations funcs
    private func configureWeather(weather: CityWeather) {
        if let forecastWeather = weather.forecast {
            self.configureForecastWeather(forecastWeather: forecastWeather)
        }
        DispatchQueue.main.async {
            if let city = weather.city {
                self.configureCityInfo(city: city)
            }
            
            if let currentWeather = weather.current {
                self.configureCurrentWeather(currentWeather: currentWeather)
            }
            self.viewModel.isLoaded.accept(true)
        }
    }
    private func configureForecastWeather(forecastWeather: ForecastWeather) {
        if let forecastByDay = forecastWeather.forecastByDay {
            viewModel.forecastByDay.accept(forecastByDay)
        }
    }
    private func configureCityInfo(city: City) {
        if let cityName = city.name {
            self.cityNameLabel.text = cityName
        }
        
        if let region = city.region, let country = city.country {
            self.cityLocation.text = "\(region), \(country)"
        }
    }
    private func configureCurrentWeather(currentWeather: CurrentWeather) {
        if let temp = currentWeather.tempC {
            self.tempLabel.text = temp.convertToCelsius()
        }
        
        if let weatherDiscr = currentWeather.condition?.text {
            self.weatherDiscrLabel.text = weatherDiscr
        }
        
        if let iconURL = currentWeather.condition?.icon {
            self.weatherIconImageView.configureIconImage(icon: iconURL)
        }
        
        if let windDir = currentWeather.windDir {
            let degree = self.compassView.changePosition(pos: windDir)
            self.compassView.changeDirection(degree: degree.degreesToRadians())
        }
        
        if let windSpeed = currentWeather.windKph {
            self.windSpeedLabel.text = "\(windSpeed) km/h"
        }
        
        if let pressure = currentWeather.pressureMb {
            self.pressureLabel.text = "\(pressure.convertToInt()) MB"
        }
        
        if let precip = currentWeather.precipMm {
            self.precipLabel.text = "\(precip.convertToInt()) MM"
        }
        
        if let humidity = currentWeather.humidity {
            self.humidityLabel.text = "\(humidity)%"
        }
        
        if let cloud = currentWeather.cloud {
            self.cloudLabel.text = "\(cloud)%"
        }
        
        if let visibility = currentWeather.visKM {
            self.visibilityLabel.text = "\(visibility.convertToInt()) KM"
        }
        
        if let uv = currentWeather.uv {
            self.uvIndexLabel.text = "\(uv.convertToInt())"
        }
    }
    
    // MARK: - flow funcs
    private func getCurrentLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    private func bind() {
        viewModel.currentWeather.subscribe { [weak self]  event in
            guard let weather = event.element else { return }
            self?.configureWeather(weather: weather)
        }
        .disposed(by: disposeBag)
        
        viewModel.forecastByDay.subscribe { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        .disposed(by: disposeBag)
        
        viewModel.currentNumber.subscribe { [weak self] event in
            self?.pageControl.currentPage = event
        }
        .disposed(by: disposeBag)
        
        viewModel.isLoaded.subscribe { event in
            guard let element = event.element else { return }
            if element {
                DispatchQueue.main.async {
                    self.removeLoadView()
                }
            } else if !element {
                self.addLoadVIew()
            } else {
                return
            }
        }
        .disposed(by: disposeBag)
    }
    private func addSwipeRecognizers() {
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeDetected))
        leftSwipeRecognizer.direction = .left
        self.forecastPlaceView.addGestureRecognizer(leftSwipeRecognizer)
        
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeDetected))
        rightSwipeRecognizer.direction = .right
        self.forecastPlaceView.addGestureRecognizer(rightSwipeRecognizer)
    }
    private func addPageControl() {
        pageControl.numberOfPages = viewModel.pageNumber
    }
    private func addCompass() {
        guard let customView = CompassView.instanceFromNib() else { return }
        self.compassView = customView
        customView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: compassPlaceView.frame.width, height: compassPlaceView.frame.height))
        compassPlaceView.layer.cornerRadius = compassPlaceView.frame.width/2
        compassPlaceView.addSubview(customView)
    }
    private func addLoadVIew() {
        guard let customView = LoadingView.instanceFromNib() else { return }
        self.loadingView = customView
        self.loadingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.loadingView)
    }
    private func removeLoadView() {
        self.loadingView.removeFromSuperview()
    }
}

// MARK: - extensions
extension MainCityViewController: SelectedCityViewControllerDelegate {
    func fetchWeather(cityWeather: CityWeather) {
        viewModel.currentWeather.accept(cityWeather)
    }
}
extension MainCityViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.forecastByDay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.identifier, for: indexPath) as? DayCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(day: viewModel.forecastByDay.value[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}

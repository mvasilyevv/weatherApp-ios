import Foundation
import RxSwift
import RxCocoa

class SelectedCitiesViewModel {
    
    // MARK: - let/var
    var selectedCityArray = BehaviorRelay<[City]>(value: [])
    var cityWeatherArray = BehaviorRelay<[CityWeather]>(value: [])
    
    // MARK: - flow funcs
    func updateWeatherInfo() {
        self.cityWeatherArray.accept([])
        for city in  self.selectedCityArray.value {
            sendWeatherRequest(city: city)
        }
    }
    private func sendWeatherRequest(city: City) {
        JSONManager.shared.sendWeatherRequest(city: city) { [weak self] weather in
            self?.cityWeatherArray.add(element: weather)
        }
    }
    func addCityInArray(city: City?) {
        guard let city = city else { return }
        selectedCityArray.add(element: city)
        save()
    }
    func save() {
        UserDefaults.standard.set(encodable: selectedCityArray.value, forKey: "cityArray")
    }
    func load() {
        guard let cities = UserDefaults.standard.value([City].self, forKey: "cityArray") else { return }
        selectedCityArray.accept(cities)
    }
}


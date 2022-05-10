import Foundation
import RxSwift
import RxCocoa

class MainCityViewModel {
    
    // MARK: - let/var
    var currentWeather = PublishRelay<CityWeather>()
    var forecastByDay = BehaviorRelay<[ForecastByDayWeather]>(value: [])
    let pageNumber: Int = 3
    var currentNumber = BehaviorRelay<Int>(value: 0)
    var isLoaded = PublishRelay<Bool>()
    
    // MARK: - flow funcs
    func sendCurrentLocationCityRequest(location: String? = nil, city: City? = nil) {
        isLoaded.accept(false)
        JSONManager.shared.sendWeatherRequest(city: city, location: location) { [weak self] weather in
            self?.currentWeather.accept(weather)
        }
    }
    func changePage(swipeDir: PageSwipeDir) {
        var currentPage = currentNumber.value
        switch swipeDir {
        case .next:
            currentPage += 1
        case .previous:
            currentPage -= 1
        }
        if canSwipe(currentPage) {
            currentNumber.accept(currentPage)
        }
    }
    private func canSwipe(_ currentPage: Int) -> Bool {
        if currentPage != pageNumber && currentPage >= 0{
            return true
        }
        return false
    }
}

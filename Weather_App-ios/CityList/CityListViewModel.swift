import Foundation
import RxSwift
import RxCocoa

class CityListViewModel {
    
    // MARK: - let/var
    var cityArray = BehaviorRelay<[City]>(value: [])
    private var searchTimer: Timer?
    
    // MARK: - flow funcs
    func getCityArray(cityPrefix: String) {
        searchTimer?.invalidate()
        searchTimer = .scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            JSONManager.shared.sendCityListRequest(cityPrefix: cityPrefix) { [weak self] city in
                self?.cityArray.accept(city)
            }
        })
    }
}

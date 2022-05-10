import Foundation

class ForecastWeather {
    var forecastByDay: [ForecastByDayWeather]?
    
    init () {}
}

class ForecastByDayWeather {
    var date: String?
    var hour: [ForecastByHourWeather]?
    
    init() {}
 }

class ForecastByHourWeather {
    var time: String?
    var temp: Double?
    var iconURL: String?
    
    init() {}
}

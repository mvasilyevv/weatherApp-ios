import Foundation

class CurrentWeather {
    var tempC: Double?
    var condition: Condition?
    var windKph: Double?
    var windDir: String?
    var isDay: Int8?
    var pressureMb: Double?
    var precipMm: Double?
    var humidity: Int?
    var cloud: Int?
    var feelsLikeC: Double?
    var visKM: Double?
    var uv: Double?
    var gustKph: Double?
    
    init() {}
}

class Condition {
    var text: String?
    var icon: String?
    
    init() {}
}

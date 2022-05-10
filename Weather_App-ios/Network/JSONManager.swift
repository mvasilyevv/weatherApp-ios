import Foundation
import CoreLocation

class JSONManager {
    static let shared = JSONManager()
    private init () {}
    
    private let weatherBaseURL = "http://api.weatherapi.com/v1"
    private let weatherAPIKey = "2f83883e9e774c74b44131925220203"
    
    // Request funcs
    func sendCityListRequest(cityPrefix: String, completion: @escaping ([City]) -> ()) {
        guard let url = URL(string: "\(weatherBaseURL)/search.json?key=\(weatherAPIKey)&q=\(cityPrefix)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data) as? [[String:Any]] else { return }
                    var cityArray: [City] = []
                    for city in json {
                        let city = self.parseCityJSON(cityData: city)
                        cityArray.append(city)
                    }
                    completion(cityArray)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    func sendWeatherRequest(city: City? = nil, location: String? = nil, completion: @escaping (CityWeather) -> ()) {
        var stringURL = ""
        if city != nil {
            guard let cityName = city?.name else { return }
            stringURL = "\(weatherBaseURL)/forecast.json?key=\(weatherAPIKey)&q=\(cityName)&days=3&aqi=no&alerts=no"
        } else if location != nil {
            guard let location = location else { return }
            stringURL = "\(weatherBaseURL)/forecast.json?key=\(weatherAPIKey)&q=\(location)&days=3&aqi=no&alerts=no"
        } else {
            return
        }
        
        guard let url = URL(string: stringURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data) as? [String:Any] else { return }
                    let cityWeather = CityWeather()
                    // MARK: - Get City Data
                    if city == nil {
                        if let locationData = json["location"] as? [String:Any] {
                            let cityByLocation = self.parseCityJSON(cityData: locationData)
                            cityWeather.city = cityByLocation
                        }
                    } else {
                        guard let city = city else { return }
                        cityWeather.city = city
                    }
                    
                    // MARK: - Get CurrentWeather Data
                    if let currentWeatherData = json["current"] as? [String:Any] {
                        let currentWeather = self.parseCurrentWeatherJSON(currentWeatherData: currentWeatherData)
                        cityWeather.current = currentWeather
                    }
                    
                    // MARK: - Get ForecastWeather Data
                    if let forecastWeatherData = json["forecast"] as? [String: Any] {
                        let forecastWeather = self.parseForecastWeatherJSON(forecastWeatherData: forecastWeatherData)
                        cityWeather.forecast = forecastWeather
                    }
                    completion(cityWeather)
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    // Configuration funcs
    private func parseCityJSON(cityData: [String:Any]) -> City {
        let city = City()
        if let name = cityData["name"] as? String {
            city.name = name
        }
        if let region = cityData["region"] as? String {
            city.region = region
        }
        if let country = cityData["country"] as? String {
            city.country = country
        }
        return city
    }
    private func parseCurrentWeatherJSON(currentWeatherData: [String:Any]) -> CurrentWeather {
        let currentWeather = CurrentWeather()
        
        if let tempC = currentWeatherData["temp_c"] as? Double {
            currentWeather.tempC = tempC
        }
        if let windKph = currentWeatherData["wind_kph"] as? Double {
            currentWeather.windKph = windKph
        }
        if let windDir = currentWeatherData["wind_dir"] as? String {
            currentWeather.windDir = windDir
        }
        if let isDay = currentWeatherData["is_day"] as? Int8 {
            currentWeather.isDay = isDay
        }
        if let pressureMb = currentWeatherData["pressure_mb"] as? Double {
            currentWeather.pressureMb = pressureMb
        }
        if let precipMm = currentWeatherData["precip_mm"] as? Double {
            currentWeather.precipMm = precipMm
        }
        if let humidity = currentWeatherData["humidity"] as? Int {
            currentWeather.humidity = humidity
        }
        if let cloud = currentWeatherData["cloud"] as? Int {
            currentWeather.cloud = cloud
        }
        if let feelsLikeC = currentWeatherData["feelslike_c"] as? Double {
            currentWeather.feelsLikeC = feelsLikeC
        }
        if let visKM = currentWeatherData["vis_km"] as? Double {
            currentWeather.visKM = visKM
        }
        if let uv = currentWeatherData["uv"] as? Double {
            currentWeather.uv = uv
        }
        if let gustKph = currentWeatherData["gust_kph"] as? Double {
            currentWeather.gustKph = gustKph
        }
        
        if let conditionData = currentWeatherData["condition"] as? [String: Any] {
            let condition = Condition()
            if let text = conditionData["text"] as? String {
                condition.text = text
            }
            if let icon = conditionData["icon"] as? String {
                condition.icon = icon
            }
            currentWeather.condition = condition
        }
        return currentWeather
    }
    private func parseForecastWeatherJSON(forecastWeatherData: [String:Any]) -> ForecastWeather {
        let forecastWeather = ForecastWeather()
        if let forecastByDayData = forecastWeatherData["forecastday"] as? [[String: Any]] {
            var forecastDayWeatherArray: [ForecastByDayWeather] = []
            
            for day in forecastByDayData {
                let forecastByDayWeather = ForecastByDayWeather()
                
                if let date = day["date"] as? String {
                    forecastByDayWeather.date = date
                }
                
                if let forecastByHourData = day["hour"] as? [[String:Any]] {
                    var forecastByHourArray = [ForecastByHourWeather]()
                    for hour in forecastByHourData {
                        let forecastByHourWeather = ForecastByHourWeather()
                        if let time = hour["time"] as? String {
                            forecastByHourWeather.time = time
                        }
                        if let temp = hour["temp_c"] as? Double {
                            forecastByHourWeather.temp = temp
                        }
                        if let conditionData = hour["condition"] as? [String:Any] {
                            if let iconURL = conditionData["icon"] as? String {
                                forecastByHourWeather.iconURL = iconURL
                            }
                        }
                        forecastByHourArray.append(forecastByHourWeather)
                    }
                    forecastByDayWeather.hour = forecastByHourArray
                }
                
                forecastDayWeatherArray.append(forecastByDayWeather)
            }
            forecastWeather.forecastByDay = forecastDayWeatherArray
        }
        return forecastWeather
    }
}

import Foundation

extension Double {
    func convertToCelsius() -> String {
        return "\(Int(self.rounded()))°C"
    }
    func convertToInt() -> Int {
        return Int(self.rounded())
    }
}

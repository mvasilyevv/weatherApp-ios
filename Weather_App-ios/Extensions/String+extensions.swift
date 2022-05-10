import Foundation

extension String {
    func convertToData() -> String {
        let formatterGet = DateFormatter()
        formatterGet.dateFormat = "yyyy-MM-dd"
        
        let formatterPrint = DateFormatter()
        formatterPrint.dateFormat = "MM/dd - EEEE"
        
        guard let date = formatterGet.date(from: self) else { return "\(self) - error" }
        return formatterPrint.string(from: date)
    }
    func convertToHour() -> String {
        let formatterGet = DateFormatter()
        formatterGet.dateFormat = "yyyy-MM-dd HH:mm"
        
        let formatterPrint = DateFormatter()
        formatterPrint.dateFormat = "HH:mm"
        
        guard let date = formatterGet.date(from: self) else { return "\(self) - error" }
        return formatterPrint.string(from: date)
    }
}

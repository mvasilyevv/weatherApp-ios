import Foundation
import UIKit

extension UIView {
    
    func rounded(radius: CGFloat = 15) {
        self.layer.cornerRadius = radius
    }
    
    func addGradient(color: GradientColor) {
        let gradient = CAGradientLayer()
        // Массив цветов для градиента. Один цвет можно повторять несколько раз.
        var startColor: CGColor
        var endColor: CGColor
       
        switch color {
        case .day:
             startColor = UIColor(red: 30/255, green: 99/255, blue: 241/255, alpha: 1).cgColor
             endColor = UIColor(red: 51/255, green: 203/255, blue: 251/255, alpha: 1).cgColor
        case .night:
            startColor = UIColor(red: 14/255, green: 88/255, blue: 132/255, alpha: 1).cgColor
            endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        }
        
        gradient.colors = [startColor, endColor]
        gradient.opacity = 0.5 // Прозрачность
        gradient.startPoint = CGPoint(x: .random(in: 0.0...1.0), y: 0)
        gradient.endPoint = CGPoint (x: .random(in: 0.0...1.0), y: 1)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowRadius = 5
        layer.shouldRasterize = true
    }
    
    func getRandom() -> CGFloat {
        return .random(in: 0.0...1.0)
    }
}

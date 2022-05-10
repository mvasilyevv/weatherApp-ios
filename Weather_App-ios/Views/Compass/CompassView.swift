import UIKit

class CompassView: UIView {
   
    static func instanceFromNib() -> CompassView? {
        guard let nib = UINib(nibName: "CompassView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CompassView else { return nil }
        return nib
    }
    
    @IBOutlet weak var arrowImageView: UIImageView!
    private let dir = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "NWN", "NW", "NNW"]

    
    func changePosition(pos: String) -> Double {
        let stepDegree = 22.5
        for (index, direction) in dir.enumerated() {
            if direction == pos {
                return stepDegree * Double(index)
            }
        }
        return 0
    }
    
    func changeDirection(degree: Double) {
        arrowImageView.transform = CGAffineTransform.identity
        guard let arrowImage = self.arrowImageView else { return }
        self.arrowImageView.transform = arrowImage.transform.rotated(by: 0)
        self.arrowImageView.transform = arrowImage.transform.rotated(by: degree)
    }
    
    
}
extension Double {
    func degreesToRadians() -> Double {
        return self * .pi / 180
    }
}

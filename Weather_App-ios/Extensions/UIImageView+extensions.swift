import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func configureIconImage(icon: String) {
        guard let url = URL(string: "http:\(icon)") else { return }
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url)
    }
}

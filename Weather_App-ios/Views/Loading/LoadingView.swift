import UIKit

class LoadingView: UIView {

    static func instanceFromNib() -> LoadingView? {
        guard let nib = UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? LoadingView else { return nil }
        return nib
    }
}

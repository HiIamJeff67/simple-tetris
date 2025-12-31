import SwiftUI
import UIKit

class LongPressViewController: UIViewController {
    private let onBegan: () -> Void
    private let onEnded: () -> Void

    init(onBegan: @escaping () -> Void, onEnded: @escaping () -> Void) {
        self.onBegan = onBegan
        self.onEnded = onEnded
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        self.view.addGestureRecognizer(longGesture)
    }

    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            onBegan()
        }
        if sender.state == .ended {
            onEnded()
        }
    }
}

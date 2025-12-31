import SwiftUI
import UIKit

struct LongPressOverlay: UIViewControllerRepresentable {
    let onBegan: () -> Void
    let onEnded: () -> Void

    func makeUIViewController(context: Context) -> LongPressViewController {
        LongPressViewController(
            onBegan: onBegan,
            onEnded: onEnded
        )
    }

    func updateUIViewController(
        _ uiViewController: LongPressViewController,
        context: Context
    ) {
    }
}

import UIKit

final class ShakeNavigationController: UINavigationController {
    var onShake: (() -> Void)?

    override var canBecomeFirstResponder: Bool {
        true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        onShake?()
    }
}

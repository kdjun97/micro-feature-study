import UIKit

final class DetailSheetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
    }
    
    deinit {
        print("❎ DetailSheetViewController deinit!")
    }
}

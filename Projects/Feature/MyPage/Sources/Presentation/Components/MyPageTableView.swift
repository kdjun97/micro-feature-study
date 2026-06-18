import UIKit

final class MyPageTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .plain)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyPageTableView {
    func setupUI() {
        separatorInset = .zero
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 44
        separatorStyle = .none
        backgroundColor = .clear
        register(SupportCell.self, forCellReuseIdentifier: SupportCell.identifier)
    }
}

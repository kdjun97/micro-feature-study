import UIKit

final class DesignSystemShowcaseListViewController: UITableViewController {
    private let items = DesignSystemShowcaseItem.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DesignSystem Demo"
        view.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ShowcaseCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowcaseCell", for: indexPath)
        let item = items[indexPath.row]

        var content = UIListContentConfiguration.subtitleCell()
        content.image = UIImage(systemName: item.symbolName)
        content.text = item.title
        content.secondaryText = item.subtitle
        content.imageProperties.tintColor = .main
        content.textProperties.font = .systemFont(ofSize: 17, weight: .semibold)
        content.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .default
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        navigationController?.pushViewController(item.makeViewController(), animated: true)
    }
}

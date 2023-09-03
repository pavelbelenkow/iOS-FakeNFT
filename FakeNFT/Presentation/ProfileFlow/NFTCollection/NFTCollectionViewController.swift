import UIKit

final class NFTCollectionViewController: UIViewController {

    private enum Constants {
        static let sortButtonSize: CGFloat = 42
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.navigationItem.rightBarButtonItem = .init(customView: sortButton)
    }

    // MARK: - UI Objects
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(NFTCollectionCell.self,
                           forCellReuseIdentifier: NFTCollectionCell.reuseIdentifier)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        return tableview
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "NFTSort"), for: .normal)
        button.tintColor = UIColor.NFTColor.black
        let width = Constants.sortButtonSize
        button.frame.size = CGSize(width: width, height: width)
        return button
    }()

    // MARK: - Private functions
    private func setupView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension NFTCollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: NFTCollectionCell.reuseIdentifier) as? NFTCollectionCell
        else { return NFTCollectionCell() }
        return cell
    }
}
// MARK: - UITableViewDelegate
extension NFTCollectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

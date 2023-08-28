import UIKit

final class RatingScreenViewController: UIViewController {
    private let viewModel = RatingScreenViewModel()
    private var navBar: UINavigationBar?
    private var listUsers: [User] = []
    private lazy var ratingTableView: UITableView = {
        let ratingTableView = UITableView()
        ratingTableView.dataSource = self
        ratingTableView.delegate = self
        ratingTableView.backgroundColor = .clear
        ratingTableView.rowHeight = 88.0
        ratingTableView.separatorStyle = .none
        ratingTableView.bounces = false
        ratingTableView.allowsMultipleSelection = false
        ratingTableView.register(RatingTableViewCell.self)
        ratingTableView.translatesAutoresizingMaskIntoConstraints = false
        return ratingTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        makeNavBarWithSortingButton()
        addSubviews()
        makeConstraints()
        viewModel.$listUsers.bind { [weak self] listUsers in
            guard let self = self else { return }
            self.listUsers = listUsers
            print(self.listUsers)
        }
        viewModel.getListUsers()
    }
    
    private func makeNavBarWithSortingButton() {
        let navBar = self.navigationController?.navigationBar
        let sortingButton = UIButton(type: .custom)
        sortingButton.setImage(
            UIImage.NFTIcon.sorting,
            for: .normal
        )
        sortingButton.addTarget(
            self,
            action: #selector(didSortingButton),
            for: .touchUpInside
        )
        let rightNavBarItem = UIBarButtonItem(customView: sortingButton)
        self.navigationItem.rightBarButtonItem = rightNavBarItem
        self.navBar = navBar
    }
    
    private func addSubviews() {
        view.addSubview(ratingTableView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            ratingTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            ratingTableView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 16
            ),
            ratingTableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            ratingTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
    
    @objc private func didSortingButton() {
        print("didSortingButton")
    }
}

extension RatingScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as RatingTableViewCell
        cell.configureRatingTableViewCell(
            with: RatingTableViewCellModel(
                indexRow: indexPath.row,
                avatar: UIImage(named: "TestImage") ?? UIImage(),
                name: "Вася",
                rating: "999"
            )
        )
        
        return cell
    }
}

extension RatingScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row + 1)")
    }
}

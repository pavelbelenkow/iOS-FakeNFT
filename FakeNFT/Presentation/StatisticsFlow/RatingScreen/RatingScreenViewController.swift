import UIKit
import ProgressHUD

final class RatingScreenViewController: UIViewController {
    private let viewModel = RatingScreenViewModel()
    private let sortedAlert = SortedAlert()
    private var navBar: UINavigationBar?
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
        bind()
        viewModel.getListUsers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ProgressHUD.dismiss()
    }
    
    private func bind() {
        viewModel.$listUsers.bind { [weak self] _ in
            guard let self = self else { return }
            self.ratingTableView.reloadData()
        }
        
        viewModel.$isLoading.bind { [weak self] isLoading in
            guard let self = self else { return }
            self.progressStatus(isLoading)
        }
    }
    
    private func progressStatus(_ isLoadind: Bool) {
        if isLoadind {
            ProgressHUD.show()
        } else {
            ProgressHUD.dismiss()
        }
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
        self.present(
            sortedAlert.callAlert(
                nameAction: viewModel.sortedByNameAlert,
                ratingAction: viewModel.sortedByRatingAlert
            ),
            animated: true
        )
    }
}

extension RatingScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as RatingTableViewCell
        cell.configureRatingTableViewCell(with: viewModel.setInfoRatingTableViewCell(indexRow: indexPath.row))
        
        return cell
    }
}

extension RatingScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfoScreenVC = UserInfoScreenViewController()
        userInfoScreenVC.userId = viewModel.listUsers[indexPath.row].id
        navigationController?.pushViewController(userInfoScreenVC, animated: true)
    }
}

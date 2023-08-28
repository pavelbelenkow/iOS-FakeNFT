import UIKit

final class RatingScreenViewController: UIViewController {
    private var navBar: UINavigationBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        makeNavBarWithSortingButton()
        addSubviews()
        makeConstraints()
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
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
        ])
    }
    
    @objc private func didSortingButton() {
        print("didSortingButton")
    }
}

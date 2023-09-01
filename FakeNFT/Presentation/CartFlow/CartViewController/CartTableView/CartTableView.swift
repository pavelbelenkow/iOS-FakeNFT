import UIKit

// MARK: - CartTableView class

final class CartTableView: UITableView {
    
    // MARK: - Properties
    
    private let viewModel: CartViewModelProtocol
    private weak var viewController: CartViewController?
    
    // MARK: - Initializers
    
    init(viewModel: CartViewModelProtocol, viewController: CartViewController) {
        self.viewModel = viewModel
        self.viewController = viewController
        super.init(frame: .zero, style: .plain)
        
        backgroundColor = .clear
        separatorStyle = .none
        rowHeight = Constants.Cart.rowHeight
        
        dataSource = self
        
        register(CartCell.self, forCellReuseIdentifier: CartCell.reuseIdentifier)
        
        allowsSelection = false
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource methods

extension CartTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.listNfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let cartCell = cell as? CartCell else {
            return UITableViewCell()
        }
        
        let nft = viewModel.listNfts[indexPath.row]
        
        cartCell.delegate = viewController
        cartCell.configure(from: nft)
        
        return cartCell
    }
}

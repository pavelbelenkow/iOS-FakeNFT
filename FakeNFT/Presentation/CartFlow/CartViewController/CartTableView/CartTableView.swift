import UIKit

final class CartTableView: UITableView {
    
    private weak var viewController: CartViewController?
    
    init(viewController: CartViewController) {
        self.viewController = viewController
        super.init(frame: .zero, style: .plain)
        
        backgroundColor = .clear
        separatorStyle = .none
        rowHeight = 140
        
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

extension CartTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let cartCell = cell as? CartCell else {
            return UITableViewCell()
        }
        
        cartCell.delegate = viewController
        cartCell.configure()
        
        return cartCell
    }
}

import UIKit

// MARK: - CurrencyCollectionView class

final class CurrencyCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    private let params = Constants.GeometricParams(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 7
    )
    
    private let viewModel: OrderPaymentViewModelProtocol
    var selectedIndexPath: IndexPath?
    
    // MARK: - Initializers
    
    init(viewModel: OrderPaymentViewModelProtocol, layout: UICollectionViewFlowLayout) {
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        
        dataSource = self
        delegate = self
        
        register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.reuseIdentifier)
        
        allowsMultipleSelection = false
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource methods

extension CurrencyCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.listCurrencies.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CurrencyCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let currencyCell = cell as? CurrencyCell else {
            return UICollectionViewCell()
        }
        
        let currency = viewModel.listCurrencies[indexPath.row]
        
        currencyCell.configure(from: currency)
        
        return currencyCell
    }
}

// MARK: - Delegate methods

extension CurrencyCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        let cellHeight = CGFloat(integerLiteral: 46)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: params.leftInset,
            bottom: params.cellSpacing,
            right: params.rightInset
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CurrencyCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let currencyCell = cell as? CurrencyCell else {
            return
        }
        
        currencyCell.isSelected = true
        
        if let selectedIndexPath, selectedIndexPath != indexPath {
            let selectedCell = collectionView.cellForItem(at: selectedIndexPath) as? CurrencyCell
            selectedCell?.isSelected = false
        }
        
        selectedIndexPath = indexPath
    }
}

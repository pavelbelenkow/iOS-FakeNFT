import Foundation

enum Constants {

    struct Cart {
        static let nftImageHeight: CGFloat = 108
        static let radius: CGFloat = 12
        static let ratingImageWidth: CGFloat = 68
        static let rowHeight: CGFloat = 140

        static let back = "Вернуться"
        static let backToCatalogue = "Вернуться в каталог"
        static let byPrice = "По цене"
        static let byRating = "По рейтингу"
        static let byTitle = "По названию"
        static let cancelText = "Отменить"
        static let cartReuseIdentifier = "cart"
        static let closeText = "Закрыть"
        static let currency = "ETH"
        static let currencyReuseIdentifier = "currency"
        static let emptyCartText = "Корзина пуста"
        static let failedToFetchCart = "Не удалось получить всю корзину"
        static let failedToFetchCurrencies = "Не удалось получить способы оплаты"
        static let failedToProceedPayment = "Не удалось оплатить"
        static let failedToRemoveNft = "Не удалось выполнить удаление NFT"
        static let failurePaymentResultText = "Упс! Что-то пошло не так :(\nПопробуйте ещё раз!"
        static let failureSound = "FailurePayment"
        static let nftText = "NFT"
        static let ok = "OK"
        static let pay = "Оплатить"
        static let payment = "К оплате"
        static let priceText = "Цена"
        static let remove = "Удалить"
        static let removeFromCart = "Вы уверены, что хотите удалить объект из корзины?"
        static let retryText = "Повторить"
        static let selectCurrencyForPayment = "Выберите способ оплаты, пожалуйста"
        static let selectTypeOfPayment = "Выберите способ оплаты"
        static let sortText = "Сортировка"
        static let successPaymentResultText = "Успех! Оплата прошла, поздравляем с покупкой!"
        static let successSound = "SuccessPayment"
        static let tryAgain = "Попробовать еще раз"
        static let unselectedPaymentMethod = "Не выбран способ оплаты"
        static let userAgreementText = "Совершая покупку, вы соглашаетесь с условиями"
        static let userAgreementLinkText = "Пользовательского соглашения"
        static let userAgreementURL = "https://yandex.ru/legal/practicum_termsofuse/"
    }

    struct GeometricParams {
        let cellCount: Int
        let leftInset: CGFloat
        let rightInset: CGFloat
        let cellSpacing: CGFloat
        let paddingWidth: CGFloat

        init(cellCount: Int,
             leftInset: CGFloat,
             rightInset: CGFloat,
             cellSpacing: CGFloat
        ) {
            self.cellCount = cellCount
            self.leftInset = leftInset
            self.rightInset = rightInset
            self.cellSpacing = cellSpacing
            self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
        }
    }
}

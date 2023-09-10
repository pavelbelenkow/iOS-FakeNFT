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
        static let failurePaymentResultText = "Упс! Что-то пошло не так :( Попробуйте ещё раз!"
        static let nftText = "NFT"
        static let ok = "OK"
        static let pay = "Оплатить"
        static let payment = "К оплате"
        static let priceText = "Цена"
        static let remove = "Удалить"
        static let removeFromCart = "Вы уверены, что хотите удалить объект из корзины?"
        static let retryText = "Повторить"
        static let selectCurrencyForPayment = "Выберите валюту для оплаты, пожалуйста😇"
        static let selectTypeOfPayment = "Выберите способ оплаты"
        static let sortText = "Сортировка"
        static let successPaymentResultText = "Успех! Оплата прошла, поздравляем с покупкой!"
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
    
    struct ErrorMessage {
        static let networkErrorTitle = "Ошибка сети"
        static let networkErrorMessage = "Проверьте подключение к сети и попробуйте еще раз"
        static let serverErrorTitle = "Ошибка сервера"
        static let serverErrorMessage = "Пожалуйста, попробуйте позже"
        static let unknownErrorTitle = "Неизвестная ошибка"
        static let unknownErrorMessage = "Произошла неизвестная ошибка. Пожалуйста, попробуйте еще раз"
    }
}

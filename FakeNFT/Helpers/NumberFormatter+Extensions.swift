import Foundation

extension NumberFormatter {

    /**
     - Форматтер для валют с настройками для текущей локали
     - Валютный символ установлен в пустую строку
     - Десятичный разделитель установлен в виде запятой, и максимальное количество знаков после нее равно 2
     */
    static var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.currencyDecimalSeparator = ","
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

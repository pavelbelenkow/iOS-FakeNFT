import Foundation

extension NumberFormatter {
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

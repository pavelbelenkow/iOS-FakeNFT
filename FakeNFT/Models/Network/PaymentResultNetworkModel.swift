import Foundation

/**
 Структура ``PaymentResultNetworkModel`` представляет сетевую модель результата оплаты заказа

 Cодержит свойства для хранения информации о результате оплаты заказа
 */
struct PaymentResultNetworkModel: Codable {
    
    /// Флаг успешности оплаты
    let success: Bool
    
    /// Идентификатор результата оплаты
    let id: String
    
    /// Идентификатор заказа
    let orderId: String
}

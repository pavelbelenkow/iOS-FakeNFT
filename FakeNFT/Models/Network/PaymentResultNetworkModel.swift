import Foundation

struct PaymentResultNetworkModel: Codable {
    let success: Bool
    let id: String
    let orderId: String
}

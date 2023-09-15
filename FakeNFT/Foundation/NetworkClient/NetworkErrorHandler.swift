import Foundation

/**
``NetworkErrorHandler`` содержит методы для обработки ошибок сетевого клиента ``NetworkClientError``
 
Содержит методы для обработки различных ошибок сетевого клиента и возвращает соответствующие сообщения об ошибках с заголовком и сообщением
*/
struct NetworkErrorHandler {

    /**
     Обрабатывает ошибку сетевого клиента и возвращает сообщение об ошибке с заголовком и сообщением
     
     - Parameter error: Ошибка сетевого клиента, которую необходимо обработать
     - Returns: Кортеж, содержащий заголовок и сообщение об ошибке
     */
    static func handleError(_ error: Error) -> (title: String, message: String) {
        var title = ""
        var message = ""

        switch error {
        case NetworkClientError.httpStatusCode(429), NetworkClientError.httpStatusCode(500):
            title = Constants.ErrorMessage.serverErrorTitle
            message = Constants.ErrorMessage.serverErrorMessage
        case NetworkClientError.urlSessionError:
            title = Constants.ErrorMessage.networkErrorTitle
            message = Constants.ErrorMessage.networkErrorMessage
        default:
            title = Constants.ErrorMessage.unknownErrorTitle
            message = Constants.ErrorMessage.unknownErrorMessage
        }

        return (title: title, message: message)
    }
}

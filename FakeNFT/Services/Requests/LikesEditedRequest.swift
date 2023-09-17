import Foundation

struct LikesEditedRequest: NetworkRequest {

    let listOfLikes: LikesEdited

    init(listOfLikes: LikesEdited) {
        self.listOfLikes = listOfLikes
    }

    var endpoint: URL? {
        get {
            URL(string: self.baseEndpoint + "profile/1")
        }
    }

    var httpMethod: HttpMethod {
        get {
            .put
        }
    }

    var dto: Encodable? {
        get {
            listOfLikes
        }
    }
}

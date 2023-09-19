import Foundation

struct LikesEditedRequest: NetworkRequest {

    let listOfLikes: LikesEdited

    init(listOfLikes: LikesEdited) {
        self.listOfLikes = listOfLikes
    }

    var endpoint: URL? { URL(string: self.baseEndpoint + "profile/1") }

    var httpMethod: HttpMethod { .put }

    var dto: Encodable? { listOfLikes }
}

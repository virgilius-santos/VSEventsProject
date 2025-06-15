import Foundation

protocol HasApi {
    var api: APIProtocol { get }
}

protocol APIProtocol {
    func fetch(
        endpoint end: @autoclosure () throws -> Endpoint,
        completion: @escaping (Result<APIDataResult, APIErrorResult>) -> Void
    )
}

struct Endpoint: Equatable {
    let method: HTTPMethod
    let url: String
    var parameters: Data?
    
    enum HTTPMethod: Equatable {
        case get, post
    }
}

struct APIDataResult {
    let data: Data
}

struct APIErrorResult: Error {
    let error: Error
}

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

enum Result<S, E> {
    case success(S)
    case error(E)
}

extension Result: Equatable where S: Equatable, E: Equatable {}

protocol Identifiable {
    var id: String { get }
}

struct Endpoint: Equatable {
    let method: HTTPMethod
    let url: String
    var parameters: Data?
}

protocol APIProtocol {
    func fetch(
        endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}

final class API: APIProtocol {
    let disposeBag = DisposeBag()

    func fetch(
        endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let parameters: [String: Any]?
        do {
            parameters = try endpoint.parameters?.toJson()
        } catch {
            completion(.error(error))
            return
        }
        request(
            endpoint.method,
            endpoint.url,
            parameters: parameters,
            encoding: URLEncoding.httpBody
        )
        .flatMap { request in
            return request.validate(statusCode: 200..<300)
                .rx.data()
        }
        .observeOn(MainScheduler.instance)
        .subscribe({ event in
            switch event {
            case .next(let data):
                completion(.success(data))
            case .error(let err):
                completion(.error(err))
            case .completed:
                break
            }
        })
        .disposed(by: disposeBag)
    }
}

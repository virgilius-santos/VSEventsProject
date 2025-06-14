import Foundation
import Alamofire
import RxSwift
import RxAlamofire

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
        endpoint end: @autoclosure () throws -> Endpoint,
        completion: @escaping (Swift.Result<Data, Error>) -> Void
    )
}

final class API: APIProtocol {
    let disposeBag = DisposeBag()

    func fetch(
        endpoint end: @autoclosure () throws -> Endpoint,
        completion: @escaping (Swift.Result<Data, Error>) -> Void
    ) {
        let parameters: [String: Any]?
        let endpoint: Endpoint
        do {
            endpoint = try end()
            parameters = try endpoint.parameters?.toJson()
        } catch {
            completion(.failure(error))
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
                completion(.failure(err))
            case .completed:
                break
            }
        })
        .disposed(by: disposeBag)
    }
}

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

final class API: APIProtocol {
    let disposeBag = DisposeBag()

    func fetch(
        endpoint end: @autoclosure () throws -> Endpoint,
        completion: @escaping (Swift.Result<APIDataResult, APIErrorResult>) -> Void
    ) {
        let parameters: [String: Any]?
        let endpoint: Endpoint
        do {
            endpoint = try end()
            parameters = try endpoint.parameters?.toJson()
        } catch {
            completion(.failure(APIErrorResult(error: error)))
            return
        }
        request(
            mapHTTPMethod(endpoint.method),
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
                completion(.success(APIDataResult(data: data)))
            case .error(let err):
                completion(.failure(APIErrorResult(error: err)))
            case .completed:
                break
            }
        })
        .disposed(by: disposeBag)
    }
    
    func mapHTTPMethod(_ method: Endpoint.HTTPMethod) -> HTTPMethod {
        switch method {
        case .get:
            .get
        case .post:
            .post
        }
    }
}

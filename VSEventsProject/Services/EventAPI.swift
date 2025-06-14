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

protocol Checkable: Encodable {
    var eventId: String { get }
    var name: String { get }
    var email: String { get }
}

protocol DetailAPIProtocol {
    func fetch<T: Decodable>(source: Identifiable, completion: @escaping (Result<T, Error>) -> Void)
    func checkIn<T: Checkable>(source: T, completion: @escaping (Result<[String: Any], Error>) -> Void)
}

struct Endpoint: Equatable {
    let method: HTTPMethod
    let url: String
    var parameters: [String: String]?
}

protocol APIProtocol {
    func fetch(
        endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}

class EventAPI: DetailAPIProtocol, APIProtocol {
    let getEventStringURL
        = "https://vsevents.free.beeceptor.com/api/events"

    let postCheckIngStringURL
        = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/checkin"

    let disposeBag = DisposeBag()

    func fetch<T: Decodable>(source: Identifiable, completion: @escaping (Result<T, Error>) -> Void) {

        var url: URL

        do {
            url = try getEventStringURL.asURL()
            url.appendPathComponent(source.id)
        } catch {
            completion(.error(error))
            return
        }

        request(.get, url)
            .flatMap { request in
                return request.validate(statusCode: 200..<300)
                    .rx.data()
            }
            .observeOn(MainScheduler.instance)
            .subscribe({ event in
                switch event {
                case .next(let json):
                    do {
                        let obj = try T.decoder(json: json)
                        completion(.success(obj))
                    } catch {
                        completion(.error(error))
                    }
                case .error(let err):
                    completion(.error(err))
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    func checkIn<T: Checkable>(
        source: T,
        completion: @escaping (Result<[String: Any], Error>) -> Void) {

        var dict: [String: Any]
        do {
            dict = try source.toJson()
        } catch {
            completion(.error(error))
            return
        }

        requestJSON(.post, postCheckIngStringURL,
                    parameters: dict,
                    encoding: URLEncoding.httpBody)
            .observeOn(MainScheduler.instance)
            .subscribe({ event in
                switch event {
                case .next(let dataReceived):
                    let (_, json) = dataReceived
                    let dict = json as! [String: Any]
                    completion(.success(dict))
                case .error(let err):
                    completion(.error(err))
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)

    }

    func fetch(
        endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        request(
            endpoint.method,
            endpoint.url,
            parameters: endpoint.parameters,
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

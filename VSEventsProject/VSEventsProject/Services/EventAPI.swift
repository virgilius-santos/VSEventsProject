//
//  EventAPI.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 16/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

enum Result<S,E> {
    case success(S)
    case error(E)
}

protocol Identifiable {
    var id: String { get }
}

protocol Checkable: Encodable {
    var eventId: String { get }
    var name: String { get }
    var email: String { get }
}

class EventAPI {
    let getEventStringURL
        = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events"

    let postCheckIngStringURL
        = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/checkin"

    let disposeBag = DisposeBag()

    func fetch<T: Decodable>(completion: @escaping (Result<[T], Error>)->()) {
        request(.get, getEventStringURL)
            .flatMap { request in
                return request.validate(statusCode: 200..<300)
                    .rx.data()
            }
            .observeOn(MainScheduler.instance)
            .subscribe( { event in
                switch event {
                case .next(let data):
                    do {
                        let decoder = JSONDecoder()
                        let obj = try decoder.decode([T].self, from: data)
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

    func fetch<T: Decodable>(source: Identifiable, completion: @escaping (Result<T, Error>)->()) {

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
            .subscribe( { event in
                switch event {
                case .next(let data):
                    do {
                        let decoder = JSONDecoder()
                        let obj = try decoder.decode(T.self, from: data)
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

    func checkIn<T: Checkable>(source: T, completion: @escaping (Error?)->()) {

        var dict: [String:Any]

        do {

            let data = try! JSONEncoder().encode(source)
            let obj = try JSONSerialization.jsonObject(with: data, options: [])
            dict = obj as! [String : Any]

        } catch {
            completion(error)
            return
        }

        request(postCheckIngStringURL,
                method: .post,
                parameters: dict,
                encoding: URLEncoding.httpBody
            ).responseJSON { (response) in
                completion(response.error)
        }
    }

}

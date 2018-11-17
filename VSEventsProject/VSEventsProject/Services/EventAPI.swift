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

class EventAPI {
    let sourceStringURL = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events"
    let disposeBag = DisposeBag()

    func fetch<T: Decodable>(completion: @escaping (Result<[T], Error>)->()) {
        request(.get, sourceStringURL)
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

        var url = try! sourceStringURL.asURL()
        url.appendPathComponent(source.id)
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


}

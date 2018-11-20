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

protocol EventAPIProtocol {
    func fetch<T: Decodable>(completion: @escaping (Result<[T], Error>)->())
}

protocol DetailAPIProtocol {
    func fetch<T: Decodable>(source: Identifiable, completion: @escaping (Result<T, Error>)->())
    func checkIn<T: Checkable>(source: T, completion: @escaping (Result<[String:Any],Error>)->())
}

class EventAPI: EventAPIProtocol, DetailAPIProtocol {
    let getEventStringURL
        = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events"

    let postCheckIngStringURL
        = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/checkin"

    let disposeBag = DisposeBag()

    func fetch<T: Decodable>(completion: @escaping (Result<[T], Error>)->()) {
        request(.get, getEventStringURL)
            .flatMap { request in
                return request.validate(statusCode: 200..<300)
                    .rx.json()
            }
            .observeOn(MainScheduler.instance)
            .subscribe( { event in
                switch event {
                case .next(let json):
                    do {
                        let obj = try [T].decoder(json: json)
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
                    .rx.json()
            }
            .observeOn(MainScheduler.instance)
            .subscribe( { event in
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
        completion: @escaping (Result<[String:Any],Error>)->()) {

        var dict: [String:Any]
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
            .subscribe( { event in
                switch event {
                case .next(let dataReceived):
                    let (_,json) = dataReceived
                    let dict = json as! [String:Any]
                    completion(.success(dict))
                case .error(let err):
                    completion(.error(err))
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)

    }

}

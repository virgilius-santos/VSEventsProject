//
//  ShowDetailsInteractorTests.swift
//  VSEventsProjectTests
//
//  Created by Virgilius Santos on 20/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import VSEventsProject

class ShowDetailsInteractorTests: QuickSpec {

    enum MockError: Error {
        case error
    }

    class APIProtocolMock: DetailAPIProtocol {
        func fetch<T>(source: Identifiable, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
            let obj = try! T.decoder(json: detailMock)
            completion(.success(obj))
        }

        func checkIn<T>(source: T, completion: @escaping (Result<[String : Any], Error>) -> Void) where T: Checkable {
            completion(.success(["code": "200"]))
        }
    }

    class APIProtocolMockError: DetailAPIProtocol {
        func fetch<T>(source: Identifiable, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
            completion(.error(MockError.error))
        }

        func checkIn<T>(source: T, completion: @escaping (Result<[String : Any], Error>) -> Void) where T: Checkable {
            completion(.error(MockError.error))
        }
    }

    class APIProtocolMockMessageError: DetailAPIProtocol {
        func fetch<T>(source: Identifiable, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
            completion(.error(MockError.error))
        }

        func checkIn<T>(source: T, completion: @escaping (Result<[String : Any], Error>) -> Void) where T: Checkable {
            completion(.success(["code": "400"]))
        }
    }

    class PresentationLogicMock: ShowDetailsPresentationLogic {
        var result: Result<Event, SingleButtonAlert>?
        var buttonAlert: SingleButtonAlert?
        var done: (() -> Void)?

        func presentDetail(_ result: Result<Event, SingleButtonAlert>) {
            self.result = result
            done?()
        }

        func presentCheckIn(_ buttonAlert: SingleButtonAlert) {
            self.buttonAlert = buttonAlert
            done?()
        }

    }

    let msgSuccess = "Sucesso!"
    let msgEmailError = "email no formato invalido, tente novamente."
    let msgError = "Houve uma falha, tente novamente mais tarte."
    
    var sei: ShowDetailsInteractor!
    var pre: PresentationLogicMock!
    var evt: Event = try! Event.decoder(json: detailMock)

    override func spec() {
        beforeEach {
            self.pre = PresentationLogicMock()
            self.sei = ShowDetailsInteractor()
            self.sei.presenter = self.pre
            self.sei.event = self.evt
        }

        describe("solicitando um evento à api") {
            context("a api esta funcionando") {
                it("validar se o request é recebido corretamente") {
                    self.sei.eventAPI = APIProtocolMock()
                    waitUntil(timeout: 10) { done in
                        self.pre.done = done
                        self.sei.fetchDetail()
                    }
                    expect(self.pre.result).notTo(beNil())
                    if let result = self.pre.result, case .success(let evts) = result {
                        expect(evts.id).to(equal((detailMock["id"] as! String)))
                    } else {
                        fail()
                    }
                }
            }

            context("a api responde com erro ") {
                it("validar se o request é recebido corretamente") {
                    self.sei.eventAPI = APIProtocolMockError()
                    waitUntil(timeout: 10) { done in
                        self.pre.done = done
                        self.sei.fetchDetail()
                    }
                    expect(self.pre.result).notTo(beNil())
                    if let result = self.pre.result, case .error(let error) = result {
                        expect(error).to(beAnInstanceOf(SingleButtonAlert.self))
                    } else {
                        fail()
                    }
                }
            }
        }

        describe("fazendo um check in") {
            context("a api esta funcionando") {
                it("validar resposta para dados invalidos") {
                    self.sei.eventAPI = APIProtocolMock()
                    waitUntil(timeout: 10) { done in
                        self.pre.done = done
                        self.sei.postCheckIn(userInfo: ("ioio", "uiui"))
                    }
                    expect(self.pre.buttonAlert).notTo(beNil())
                    if let result = self.pre.buttonAlert {
                        expect(result).to(beAnInstanceOf(SingleButtonAlert.self))
                        expect(result.message).to(equal(self.msgEmailError))
                    } else {
                        fail()
                    }
                }

                it("validar resposta para dados VALIDOS") {
                    self.sei.eventAPI = APIProtocolMock()
                    waitUntil(timeout: 10) { done in
                        self.pre.done = done
                        self.sei.postCheckIn(userInfo: ("ioio", "uiui@acad.com"))
                    }
                    expect(self.pre.buttonAlert).notTo(beNil())
                    if let result = self.pre.buttonAlert {
                        expect(result).to(beAnInstanceOf(SingleButtonAlert.self))
                        expect(result.message).to(equal(self.msgSuccess))
                    } else {
                        fail()
                    }
                }
            }

            context("a api NAO esta funcionando") {
                it("Api envia um erro") {
                    self.sei.eventAPI = APIProtocolMockError()
                    waitUntil(timeout: 10) { done in
                        self.pre.done = done
                        self.sei.postCheckIn(userInfo: ("ioio", "uiui@acad.com"))
                    }
                    expect(self.pre.buttonAlert).notTo(beNil())
                    if let result = self.pre.buttonAlert {
                        expect(result).to(beAnInstanceOf(SingleButtonAlert.self))
                        expect(result.message).to(equal(self.msgError))
                    } else {
                        fail()
                    }
                }

                it("API envia dados incorretos") {
                    self.sei.eventAPI = APIProtocolMockMessageError()
                    waitUntil(timeout: 10) { done in
                        self.pre.done = done
                        self.sei.postCheckIn(userInfo: ("ioio", "uiui@acad.com"))
                    }
                    expect(self.pre.buttonAlert).notTo(beNil())
                    if let result = self.pre.buttonAlert {
                        expect(result).to(beAnInstanceOf(SingleButtonAlert.self))
                        expect(result.message).to(equal(self.msgError))
                    } else {
                        fail()
                    }
                }
            }
        }

    }

}

var detailMock: [String: Any] =
["id":"1","title":"Feira de adoÃ§Ã£o de animais na RedenÃ§Ã£o","price":29.99,"latitude":"-30.0392981","longitude":"-51.2146267","image":"http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png","description":"O Patas Dadas estarÃ¡ na RedenÃ§Ã£o, nesse domingo, com cÃ£es para adoÃ§Ã£o e produtos Ã  venda!\n\nNa ocasiÃ£o, teremos bottons, bloquinhos e camisetas!\n\nTraga seu Pet, os amigos e o chima, e venha aproveitar esse dia de sol com a gente e com alguns de nossos peludinhos - que estarÃ£o prontinhos para ganhar o â™¥ de um humano bem legal pra chamar de seu. \n\nAceitaremos todos os tipos de doaÃ§Ã£o:\n- guias e coleiras em bom estado\n- raÃ§Ã£o (as que mais precisamos no momento sÃ£o sÃªnior e filhote)\n- roupinhas \n- cobertas \n- remÃ©dios dentro do prazo de validade","date":1534784400000,"people":[["id":"1","eventId":"1","name":"Alexandre Pires","picture":"https://images.pexels.com/photos/1292306/pexels-photo-1292306.jpeg"],["id":"2","eventId":"1","name":"JÃ©ssica Souza","picture":"https://images.pexels.com/photos/1310522/pexels-photo-1310522.jpeg"],["id":"6","eventId":"1","name":"Boanerges Oliveira","picture":"https://images.pexels.com/photos/542282/pexels-photo-542282.jpeg"],["id":"7","eventId":"1","name":"Felipe Smith","picture":"https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg"],["id":"11","eventId":"1","name":"Paulo Santos","picture":"https://images.pexels.com/photos/1334945/pexels-photo-1334945.jpeg"]],"cupons":[["id":"1","eventId":"1","discount":10]]]

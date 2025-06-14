import Foundation
import Quick
import Nimble

@testable import VSEventsProject

final class ShowEventsInteractorTests: QuickSpec {
    typealias Sut = ShowEventsInteractor
    
    final class Doubles {
        let presenter = ShowEventsPresentationLogicMock()
        let eventAPI = EventAPIProtocolMock()
    }
    
    func makeSut() -> (Sut, Doubles) {
        let doubles = Doubles()
        let sut = Sut(
            presenter: doubles.presenter,
            eventAPI: doubles.eventAPI
        )
        return (sut, doubles)
    }
    
    override func spec() {
        describe("ShowEventsInteractor") {
            var sut: Sut!
            var doubles: Doubles!
            
            beforeEach {
                (sut, doubles) = self.makeSut()
            }
            
            context("when fetching events") {
                beforeEach {
                    sut.fetchEvents()
                }
                
                it("should make exactly one API request") {
                    expect(doubles.eventAPI.receivedRequests).to(haveCount(1))
                }
                
                it("should not response imeadety") {
                    expect(doubles.presenter.resultReceived).to(beEmpty())
                }
                
                context("with successful response") {
                    beforeEach {
                        let resultSent = Result<[Event], Error>.success([])
                        doubles.eventAPI.simulateNetworkResponse(with: resultSent)
                    }
                    
                    it("should deliver empty events") {
                        let resultExpected = Result<[Event], SingleButtonAlert>.success([])
                        expect(doubles.presenter.resultReceived).to(equal([resultExpected]))
                    }
                }
                
                context("when API fails") {
                    beforeEach {
                        let resultSent = Result<[Event], Error>.error(MockError.error)
                        doubles.eventAPI.simulateNetworkResponse(with: resultSent)
                    }
                    
                    it("should deliver error alert") {
                        let alertMock = SingleButtonAlert.fixture(
                            title: "Erro Na Busca dos Dados",
                            message: "Tente novamente",
                            action: .fixture(buttonTitle: "OK")
                        )
                        let resultExpected = Result<[Event], SingleButtonAlert>.error(alertMock)
                        expect(doubles.presenter.resultReceived).to(equal([resultExpected]))
                    }
                }
            }
        }
    }
}

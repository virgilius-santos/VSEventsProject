import Foundation
import Quick
import Nimble

@testable import VSEventsProject

final class ShowEventsInteractorTests: QuickSpec {
    typealias Sut = ShowEventsInteractor
    
    final class Doubles {
        let presenter = ShowEventsPresentationLogicMock()
        let eventAPI = EventAPIProtocolMock()
        
        var anyMessages = AnyMessage()
    }
    
    func makeSut() -> (Sut, Doubles) {
        let doubles = Doubles()
        let sut = Sut(
            presenter: doubles.presenter,
            eventAPI: doubles.eventAPI
        )
        doubles.presenter.anyMessages = doubles.anyMessages
        doubles.eventAPI.anyMessages = doubles.anyMessages
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
                
                it("should make exactly only API request") {
                    expect(doubles.anyMessages).to(equal([
                        EventAPIProtocolMock.Message.fetchEvents
                    ]))
                }
                
                context("with successful response") {
                    beforeEach {
                        doubles.anyMessages.clearMessages()
                        let resultSent = Result<[Event], Error>.success([])
                        doubles.eventAPI.simulateNetworkResponse(with: resultSent)
                    }
                    
                    it("should deliver empty events") {
                        let resultExpected = Result<[Event], SingleButtonAlert>.success([])
                        expect(doubles.anyMessages).to(equal([
                            ShowEventsPresentationLogicMock.Message.displayEvents(resultExpected)
                        ]))
                    }
                }
                
                context("when API fails") {
                    beforeEach {
                        doubles.anyMessages.clearMessages()
                        let resultSent = Result<[Event], Error>.failure(MockError.error)
                        doubles.eventAPI.simulateNetworkResponse(with: resultSent)
                    }
                    
                    it("should deliver error alert") {
                        let alertMock = SingleButtonAlert.fixture(
                            title: "Erro Na Busca dos Dados",
                            message: "Tente novamente",
                            action: .fixture(buttonTitle: "OK")
                        )
                        let resultExpected = Result<[Event], SingleButtonAlert>.failure(alertMock)
                        expect(doubles.anyMessages).to(equal([
                            ShowEventsPresentationLogicMock.Message.displayEvents(resultExpected)
                        ]))
                    }
                }
            }
        }
    }
}

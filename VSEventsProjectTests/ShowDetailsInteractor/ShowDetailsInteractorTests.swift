import Foundation
import Quick
import Nimble

@testable import VSEventsProject

final class ShowDetailsInteractorTests: QuickSpec {
    typealias Sut = ShowDetailsInteractor
    
    final class Doubles {
        let presenter = ShowDetailsPresentationLogicMock()
        let eventAPI = DetailAPIProtocolMock()
        
        var anyMessages = AnyMessage()
        
        let event = Event.event()
        let initialEvent = Event.event(id: "5")
    }
    
    func makeSut() -> (Sut, Doubles) {
        let doubles = Doubles()
        let sut = Sut.init(
            presenter: doubles.presenter,
            eventAPI: doubles.eventAPI,
            event: doubles.initialEvent
        )
        
        doubles.presenter.anyMessages = doubles.anyMessages
        doubles.eventAPI.anyMessages = doubles.anyMessages
        
        return (sut, doubles)
    }

    let msgSuccess = "Sucesso!"
    let msgEmailError = "email no formato invalido, tente novamente."
    let msgError = "Houve uma falha, tente novamente mais tarte."
    
    override func spec() {
        describe("ShowDetailsInteractor") {
            var sut: Sut!
            var doubles: Doubles!
            
            beforeEach {
                (sut, doubles) = self.makeSut()
            }
            
            context("when fetching events") {
                beforeEach {
                    sut.fetchDetail()
                }
                
                it("should make exactly one API request") {
                    expect(doubles.anyMessages).to(equal([
                        DetailAPIProtocolMock.Message.fetch(doubles.initialEvent)
                    ]))
                }
                
                context("with successful response") {
                    beforeEach {
                        doubles.anyMessages.clearMessages()
                        let resultSent = Result<Event, Error>.success(doubles.event)
                        doubles.eventAPI.simulateFetchResponse(with: resultSent)
                    }
                    
                    it("should deliver empty events") {
                        let resultExpected = Result<Event, SingleButtonAlert>.success(doubles.event)
                        expect(doubles.anyMessages).to(equal([
                            ShowDetailsPresentationLogicMock.Message.presentDetail(resultExpected)
                        ]))
                    }
                }
                
                context("when API fails") {
                    beforeEach {
                        doubles.anyMessages.clearMessages()
                        let resultSent = Result<Event, Error>.error(MockError.error)
                        doubles.eventAPI.simulateFetchResponse(with: resultSent)
                    }
                    
                    it("should deliver error alert") {
                        let alertMock = SingleButtonAlert.fixture(
                            title: "Detalhes",
                            message: MockError.error.localizedDescription,
                            action: .fixture(buttonTitle: "OK")
                        )
                        let resultExpected = Result<Event, SingleButtonAlert>.error(alertMock)
                        expect(doubles.anyMessages).to(equal([
                            ShowDetailsPresentationLogicMock.Message.presentDetail(resultExpected)
                        ]))
                    }
                }
            }
            
            context("when post check in with nil values") {
                beforeEach {
                    sut.postCheckIn(userInfo: nil)
                }
                it("should deliver error alert") {
                    let alertMock = SingleButtonAlert.fixture(
                        title: "Check In",
                        message: "dados invalidos",
                        action: .fixture(buttonTitle: "OK")
                    )
                    expect(doubles.anyMessages).to(equal([
                        ShowDetailsPresentationLogicMock.Message.presentCheckIn(alertMock)
                    ]))
                }
            }
            
            context("when post check in with invalid email") {
                beforeEach {
                    sut.postCheckIn(userInfo: ("ioio", "uiui"))
                }
                
                it("should deliver error alert") {
                    let alertMock = SingleButtonAlert.fixture(
                        title: "Check In",
                        message: "email no formato invalido, tente novamente.",
                        action: .fixture(buttonTitle: "OK")
                    )
                    expect(doubles.anyMessages).to(equal([
                        ShowDetailsPresentationLogicMock.Message.presentCheckIn(alertMock)
                    ]))
                }
            }
            
            context("when post check in with valid data") {
                beforeEach {
                    sut.postCheckIn(userInfo: ("ioio", "uiui@acad.com"))
                }
                
                it("should call check in api") {
                    let user = User(
                        name: "ioio",
                        email: "uiui@acad.com",
                        eventId: doubles.initialEvent.id
                    )
                    expect(doubles.anyMessages).to(equal([
                        DetailAPIProtocolMock.Message.checkIn(user)
                    ]))
                }
                
                context("with successful response") {
                    beforeEach {
                        doubles.anyMessages.clearMessages()
                        let resultSent = Result<[String: Any], Error>.success(
                            ["code": "200"]
                        )
                        doubles.eventAPI.simulateCheckInResponse(with: resultSent)
                    }
                    
                    it("should deliver empty events") {
                        let alertMock = SingleButtonAlert.fixture(
                            title: "Check In",
                            message: "Sucesso!",
                            action: .fixture(buttonTitle: "OK")
                        )
                        expect(doubles.anyMessages).to(equal([
                            ShowDetailsPresentationLogicMock.Message.presentCheckIn(alertMock)
                        ]))
                    }
                }
                
                context("when API fails with error") {
                    beforeEach {
                        doubles.anyMessages.clearMessages()
                        let resultSent = Result<[String: Any], Error>.error(MockError.error)
                        doubles.eventAPI.simulateCheckInResponse(with: resultSent)
                    }
                    
                    it("should deliver error alert") {
                        let alertMock = SingleButtonAlert.fixture(
                            title: "Check In",
                            message: "Houve uma falha, tente novamente mais tarte.",
                            action: .fixture(buttonTitle: "OK")
                        )
                        expect(doubles.anyMessages).to(equal([
                            ShowDetailsPresentationLogicMock.Message.presentCheckIn(alertMock)
                        ]))
                    }
                }
                
                context("when API fails with invalid data") {
                    beforeEach {
                        doubles.anyMessages.clearMessages()
                        let resultSent = Result<[String: Any], Error>.success([:])
                        doubles.eventAPI.simulateCheckInResponse(with: resultSent)
                    }
                    
                    it("should deliver error alert") {
                        let alertMock = SingleButtonAlert.fixture(
                            title: "Check In",
                            message: "Houve uma falha, tente novamente mais tarte.",
                            action: .fixture(buttonTitle: "OK")
                        )
                        expect(doubles.anyMessages).to(equal([
                            ShowDetailsPresentationLogicMock.Message.presentCheckIn(alertMock)
                        ]))
                    }
                }
            }
        }
    }

}

import Quick
import Nimble
import RxSwift
import RxTest
import RxCocoa
import RxBlocking

@testable import VSEventsProject

final class ShowEventsViewModelSpec: QuickSpec {
    typealias Sut = ShowEventsViewModel
    typealias EventDTO = VSEventsProject.Event
    
    final class Doubles {
        let router = ShowEventsRoutingLogicMock()
        let eventAPI = EventAPIProtocolMock()
        let disposeBag = DisposeBag()
        
        var anyMessages = AnyMessage()
        
        let event = EventDTO(
            id: "1",
            title: "Evento Teste 1",
            price: 100.0,
            latitude: -23.55,
            longitude: -46.63,
            image: URL(string: "https://via.placeholder.com/300.png/09f/fff?text=Evento1")!,
            description: "Descrição do evento teste 1.",
            date: Date(),
            people: [
                Person(id: "p1", eventId: "1", name: "Participante 1", picture: "https://via.placeholder.com/50.png/09f/fff?text=P1")
            ],
            cupons: [
                Cupom(id: "c1", eventId: "1", discount: 10)
            ]
        )
        lazy var eventsMock = [event]
        let emptyEventsMock = [EventDTO]()
        let titleExpected = "Lista de Eventos"
        let loadingActivated = true
        let loadingDeactivated = false
        let isRefreshingActivated = true
        let isRefreshingDeactivated = false
        
        let viewDidLoadPublisher = PublishSubject<Void>()
        let refreshPublisher = PublishSubject<Void>()
        let itemSelectedPublisher = PublishSubject<EventCellViewModel>()
        
        var input: ShowEventsViewModel.Input {
            .init(
                viewDidLoad: viewDidLoadPublisher,
                refresh: refreshPublisher,
                itemSelected: itemSelectedPublisher
            )
        }
        
        func bindOutput(_ output: ShowEventsViewModel.Output) {
            bindOutput(output.cells.map({ $0.map(\.eventItem) }).asObservable())
            bindOutput(output.title.asObservable())
            bindOutput(output.showError.asObservable())
            bindOutput(output.isLoading.asObservable())
            bindOutput(output.isRefreshing.asObservable())
        }
        
        func bindOutput<T: Equatable>(_ observable: Observable<T>) {
            observable
                .subscribe(onNext: { [weak self] in self?.anyMessages.appendLast(of: [$0]) })
                .disposed(by: disposeBag)
        }
    }
    
    func makeSut() -> (Sut, Doubles) {
        let doubles = Doubles()
        let sut = Sut(
            eventAPI: doubles.eventAPI,
            router: doubles.router
        )
        doubles.router.anyMessages = doubles.anyMessages
        doubles.eventAPI.anyMessages = doubles.anyMessages
        return (sut, doubles)
    }
    
    override func spec() {
        var sut: Sut!
        var doubles: Doubles!
        
        beforeEach {
            (sut, doubles) = self.makeSut()
        }

        describe("ShowEventsViewModel") {
            context("on transform") {
                beforeEach {
                    let output = sut.transform(input: doubles.input)
                    doubles.bindOutput(output)
                }
                
                it("should emit initial title and loading state") {
                    expect(doubles.anyMessages).to(equal([
                        doubles.emptyEventsMock,
                        doubles.titleExpected,
                        doubles.loadingActivated
                    ]))
                }
                
                context("when viewDidLoad is triggered") {
                    beforeEach {
                        doubles.anyMessages.clearMessages()
                        doubles.viewDidLoadPublisher.onNext(())
                    }
                    
                    it("should call fetchEvents and emit loading state") {
                        expect(doubles.anyMessages).to(equal([
                            doubles.loadingActivated,
                            EventAPIProtocolMock.Message.fetchEvents
                        ]))
                    }
                    
                    context("with successful response") {
                        beforeEach {
                            doubles.anyMessages.clearMessages()
                            let resultSent = Result<[EventDTO], Error>.success(doubles.eventsMock)
                            doubles.eventAPI.simulateNetworkResponse(with: resultSent)
                        }
                        
                        it("should deliver empty events") {
                            expect(doubles.anyMessages).to(equal([
                                doubles.eventsMock,
                                doubles.loadingDeactivated
                            ]))
                        }
                    }
                    
                    context("when API fails") {
                        beforeEach {
                            doubles.anyMessages.clearMessages()
                            let resultSent = Result<[EventDTO], Error>.failure(MockError.error)
                            doubles.eventAPI.simulateNetworkResponse(with: resultSent)
                        }
                        
                        it("should deliver error alert") {
                            let alertMock = SingleButtonAlert.fixture(
                                title: "Erro Na Busca dos Dados",
                                message: "Tente novamente",
                                action: .fixture(buttonTitle: "OK")
                            )
                            expect(doubles.anyMessages).to(equal([
                                alertMock,
                                doubles.loadingDeactivated
                            ]))
                        }
                    }
                }
                
                context("when refresh is triggered") {
                    beforeEach {
                        doubles.anyMessages.clearMessages()
                        doubles.refreshPublisher.onNext(())
                    }
                    
                    it("should call fetchEvents and emit refresh start") {
                        expect(doubles.anyMessages).to(equal([
                            doubles.isRefreshingActivated,
                            EventAPIProtocolMock.Message.fetchEvents
                        ]))
                    }
                    
                    context("and API returns success") {
                        beforeEach {
                            doubles.anyMessages.clearMessages()
                            doubles.eventAPI.simulateNetworkResponse(with: .success(doubles.eventsMock))
                        }
                        
                        it("should emit events and finish refresh") {
                            expect(doubles.anyMessages).to(equal([
                                doubles.eventsMock,
                                doubles.isRefreshingDeactivated
                            ]))
                        }
                    }
                }
                
                context("when item is selected") {
                    beforeEach {
                        doubles.anyMessages.clearMessages()
                        doubles.itemSelectedPublisher.onNext(doubles.event)
                    }
                    
                    it("should route to event detail") {
                        expect(doubles.router.messages).to(equal([.routeToDetail(doubles.event)]))
                    }
                }
            }
        }
    }
}


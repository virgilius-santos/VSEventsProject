import UIKit

protocol ShowDetailsBusinessLogic {
    func fetchDetail()
    func postCheckIn(userInfo: (String, String)?)
}

final class ShowDetailsInteractor {
    let presenter: ShowDetailsPresentationLogic
    let eventAPI: DetailAPIProtocol
    let event: Event
    
    init(presenter: ShowDetailsPresentationLogic, eventAPI: DetailAPIProtocol, event: Event) {
        self.presenter = presenter
        self.eventAPI = eventAPI
        self.event = event
    }
}

extension ShowDetailsInteractor: ShowDetailsBusinessLogic {
    func fetchDetail() {
        eventAPI.fetchEvent(event) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let evt):
                presenter.presentDetail(.success(evt))
            case .error(let error):
                sendDetailMessage(msg: error.localizedDescription)
            }
        }
    }
    
    private func sendDetailMessage(msg: String) {
        let buttonAlert = SingleButtonAlert(
            title: "Detalhes",
            message: msg,
            action: AlertAction(buttonTitle: "OK")
        )
        self.presenter.presentDetail(.error(buttonAlert))
    }

    func postCheckIn(userInfo: (String, String)?) {
        guard let (name, email) = userInfo else {
            self.sendCheckInMessage(msg: "dados invalidos")
            return
        }
        guard email.match(.email) else {
            self.sendCheckInMessage(msg: "email no formato invalido, tente novamente.")
            return
        }
        
        let user = User(name: name, email: email, eventId: event.id)
        eventAPI.checkIn(user: user) { result in
            if case .success(let model) = result, model.code == "200" {
                self.sendCheckInMessage(msg: "Sucesso!")
            } else {
                self.sendCheckInMessage(msg: "Houve uma falha, tente novamente mais tarte.")
            }
        }
    }

    private func sendCheckInMessage(msg: String) {
        let buttonAlert = SingleButtonAlert(
            title: "Check In",
            message: msg,
            action: AlertAction(buttonTitle: "OK")
        )
        self.presenter.presentCheckIn(buttonAlert)
    }
}

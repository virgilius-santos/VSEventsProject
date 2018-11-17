//
//  ShowDetailsInteractor.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 16/11/18.
//  Copyright (c) 2018 Virgilius Santos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowDetailsBusinessLogic {
    func fetchDetail()
    func postCheckIn(userInfo: (String, String)?)
}

protocol ShowDetailsDataStore {
    var event: Event? { get set }
}

class ShowDetailsInteractor: ShowDetailsDataStore {
    var presenter: ShowDetailsPresentationLogic?
    var eventAPI: EventAPI?
    var event: Event?

}

extension ShowDetailsInteractor: ShowDetailsBusinessLogic {
    func fetchDetail() {
        eventAPI = EventAPI()
        eventAPI?.fetch(source: event!) { [weak self] (result: Result<Event, Error>) in

            switch result {

            case .success(let evt):
                self?.presenter?.presentDetail(.success(evt))

            case .error(let error):
                let alert = AlertAction(buttonTitle: "claro", handler: nil)
                let buttonAlert
                    = SingleButtonAlert(title: "azul",
                                        message: error.localizedDescription,
                                        action: alert)
                self?.presenter?.presentDetail(.error(buttonAlert))
            }

        }
    }

    func postCheckIn(userInfo: (String, String)?) {
        eventAPI = EventAPI()

        let (name,email) = userInfo!
        let user = User(name: name, email: email, eventId: event!.id)

        eventAPI?.checkIn(source: user) {(error) in
            if error == nil {
                let alert = AlertAction(buttonTitle: "Ok", handler: nil)
                let buttonAlert
                    = SingleButtonAlert(title: "Check In",
                                        message: "Sucesso!",
                                        action: alert)
                DispatchQueue.main.async {
                    self.presenter?.presentCheckIn(buttonAlert)
                }
            } else {
                let alert = AlertAction(buttonTitle: "Ok", handler: nil)
                let buttonAlert
                    = SingleButtonAlert(title: "Check In",
                                        message: "Houve uma falha, tente novamente mais tarte.",
                                        action: alert)
                DispatchQueue.main.async {
                    self.presenter?.presentCheckIn(buttonAlert)
                }
            }
        }
    }
}

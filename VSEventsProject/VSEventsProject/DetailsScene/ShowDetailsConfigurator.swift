//
//  ShowDetailsConfigurator.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class ShowDetailsConfigurator {

    private let nibName = String(describing: ShowDetailsViewController.self)

    var viewController: ShowDetailsViewController

    init() {
        viewController = ShowDetailsViewController(nibName: nibName, bundle: nil)
        let interactor = ShowDetailsInteractor()
        let presenter = ShowDetailsPresenter()
        let router = ShowDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}

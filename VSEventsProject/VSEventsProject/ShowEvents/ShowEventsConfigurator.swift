//
//  ShowEventsConfigurator.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class ShowEventsConfigurator {

    private let nibName = String(describing: ShowEventsViewController.self)

    var viewController: ShowEventsViewController

    init(window: UIWindow) {
        viewController = ShowEventsViewController(nibName: nibName, bundle: nil)
        let interactor = ShowEventsInteractor()
        let presenter = ShowEventsPresenter()
        let router = ShowEventsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        let nav = UINavigationController(rootViewController: viewController)
        window.rootViewController = nav
    }
}

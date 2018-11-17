//
//  ShowDetailsPresenter.swift
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

protocol ShowDetailsPresentationLogic {
    func presentDetail(_ result: Result<Event, Error>)
}

class ShowDetailsPresenter {

    weak var viewController: ShowDetailsDisplayLogic?

}

extension ShowDetailsPresenter: ShowDetailsPresentationLogic {

    func presentDetail(_ result: Result<Event, Error>) {
        switch result {
            
        case .success(let event):
            viewController?.displayDetail(viewModel: event)

        case .error(_):
            break
        }
    }
}


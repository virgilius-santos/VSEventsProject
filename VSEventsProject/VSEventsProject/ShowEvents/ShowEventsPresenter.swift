//
//  ShowEventsPresenter.swift
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

protocol ShowEventsPresentationLogic
{
  func presentSomething(response: ShowEvents.Something.Response)
}

class ShowEventsPresenter: ShowEventsPresentationLogic
{
  weak var viewController: ShowEventsDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: ShowEvents.Something.Response)
  {
    let viewModel = ShowEvents.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
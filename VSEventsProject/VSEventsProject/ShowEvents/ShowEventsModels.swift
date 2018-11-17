//
//  ShowEventsModels.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol EventCellViewModel {
    var eventItem: Event { get }
    var title: String { get }
}

extension Event: EventCellViewModel {
    var eventItem: Event {
        return self
    }
}

class EventsTableViewViewModel {

    var eventCells: Observable<[EventCellViewModel]> {
        return cells.asObservable()
    }
    let cells = BehaviorRelay<[EventCellViewModel]>(value: [])

    let disposeBag = DisposeBag()

}

class EventTableViewCell: UITableViewCell {
    var viewModel: EventCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        textLabel?.text = viewModel?.title
    }
}

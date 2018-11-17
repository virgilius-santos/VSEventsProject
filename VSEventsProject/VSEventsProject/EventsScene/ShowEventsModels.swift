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
    var imageUrl: URL { get }
}

extension Event: EventCellViewModel {
    var imageUrl: URL {
        return image
    }

    var eventItem: Event {
        return self
    }
}

class EventsTableViewViewModel {

    var eventCells: Observable<[EventCellViewModel]> {
        return cells.asObservable()
    }
    let cells = BehaviorRelay<[EventCellViewModel]>(value: [])

    let onShowError = PublishSubject<SingleButtonAlert>()
    
    let disposeBag = DisposeBag()

}



//
//  ShowDetailsModels.swift
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
import RxSwift
import RxCocoa
import MapKit

protocol DetailInfo {
    var title: String { get }
    var imageUrl: URL { get }
    var price: Double { get }
    var region: MKCoordinateRegion { get }
    var coordinate: CLLocationCoordinate2D { get }
    var annotation: MKAnnotation { get }
    var description: String { get }
    var dateString: String { get }
    var people: [Person] { get }
    var cupons: [Cupom] { get }
}

extension Event: DetailInfo {
    var dateString: String {
        return date.toString()
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var region: MKCoordinateRegion {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion
            = MKCoordinateRegion(center: coordinate,
                                 latitudinalMeters: regionRadius * 2.0,
                                 longitudinalMeters: regionRadius * 2.0)
        return coordinateRegion
    }

    var annotation: MKAnnotation {
        let anot = MKPointAnnotation()
        anot.coordinate = coordinate
        return anot
    }
}

class DetailViewModel {

    var eventDetail: Observable<DetailInfo> {
        return event.asObservable()
    }
    let event = PublishRelay<DetailInfo>()

    var eventCells: Observable<[PersonCellViewModel]> {
        return cells.asObservable()
    }
    let cells = BehaviorRelay<[PersonCellViewModel]>(value: [])

    let onShowError = PublishSubject<SingleButtonAlert>()
    
    let disposeBag = DisposeBag()

    init() {
        eventDetail
            .map({$0.people})
            .bind(to: cells)
            .disposed(by: disposeBag)
    }
    
}

protocol PersonCellViewModel {
    var eventItem: Person { get }
    var title: String { get }
    var imageUrl: URL { get }
}

extension Person: PersonCellViewModel {
    var title: String {
        return self.name
    }

    var imageUrl: URL {
        return self.picture
    }

    var eventItem: Person {
        return self
    }
}

//
//  ShowEventsViewController.swift
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
import RxSwiftExt

protocol ShowEventsDisplayLogic: class {
    var title: String? { get set }
    var viewModel: EventsTableViewViewModel { get }
}

class ShowEventsViewController: UIViewController, ShowEventsDisplayLogic {

    var viewModel = EventsTableViewViewModel()

    var interactor: ShowEventsBusinessLogic?

    var router: (ShowEventsRoutingLogic & ShowEventsDataPassing)?

    var disposeBag = DisposeBag()

    let cellIdentifier = String(describing: EventTableViewCell.self)

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupTableView()
        fetchEvents()
    }

    @IBOutlet weak var tableView: UITableView!

    func bindViewModel() {

        viewModel
            .eventCells
            .bind(to: self.tableView.rx.items(cellIdentifier: cellIdentifier, cellType: EventTableViewCell.self)) { (row, element, cell) in

                cell.viewModel = element
                
            }.disposed(by: disposeBag)

    }

    func setupTableView() {

        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        tableView.rx
            .modelSelected(EventCellViewModel.self)
            .subscribe(onNext:  { [weak self] value in
                self?.router?.routeToDetail(value)
            })
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: false)
            }).disposed(by: disposeBag)

    }

    func fetchEvents() {
        interactor?.fetchEvents()
    }
}



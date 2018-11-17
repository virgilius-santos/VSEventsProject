//
//  ShowDetailsViewController.swift
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
import RxAlamofire
import RxMapKit
import AlamofireImage
import MapKit

protocol ShowDetailsDisplayLogic: class {
    var viewModel: DetailViewModel { get }
}

class ShowDetailsViewController: UIViewController, ShowDetailsDisplayLogic, SingleButtonDialogPresenter {

    var interactor: ShowDetailsBusinessLogic?

    var router: (ShowDetailsRoutingLogic & ShowDetailsDataPassing)?

    var viewModel = DetailViewModel()

    var disposeBag = DisposeBag()

    let cellIdentifier = String(describing: PersonCollectionViewCell.self)

    var userController = UserController()

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupCollectionView()
        setupButtons()
        setupUserController()
        interactor?.fetchDetail()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventPoster.af_cancelImageRequest()
    }

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var eventPoster: UIImageView!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var participantsCollectionView: UICollectionView!

    @IBOutlet weak var checkInButton: UIButton!

    @IBOutlet weak var shareButton: UIButton!

    @IBOutlet weak var mapView: MKMapView!


    func bindViewModel() {

        viewModel
            .eventDetail
            .map({$0.title})
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel
            .event
            .map({$0.imageUrl})
            .subscribe { [weak self] (event) in
                switch event {
                case .next(let url):
                    self?.eventPoster.getImage(withURL: url)
                    break
                case .error(_):
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

        viewModel
            .eventDetail
            .map({"\($0.price)"})
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel
            .eventDetail
            .map({$0.description})
            .bind(to: descriptionTextView.rx.text)
            .disposed(by: disposeBag)

        viewModel
            .eventDetail
            .map({$0.dateString})
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel
            .eventDetail
            .map({$0.region})
            .bind(to: mapView.rx.region)
            .disposed(by: disposeBag)

        viewModel
            .eventDetail
            .map({[$0.annotation]})
            .bind(to: mapView.rx.annotationsToShowToAnimate)
            .disposed(by: disposeBag)

        let observable : Observable<SingleButtonAlert> = viewModel.onShowError

        observable
            .subscribe(onNext: { [weak self] alert in

                self?.presentSingleButtonDialog(alert: alert)

            }).disposed(by: disposeBag)

    }

    func setupCollectionView() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        participantsCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)

        viewModel
            .eventCells
            .bind(to: self.participantsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: PersonCollectionViewCell.self))
            { (row, element, cell) in

                cell.viewModel = element

            }.disposed(by: disposeBag)

        
    }

    func setupButtons() {
        shareButton
            .rx
            .tap
            .bind { [unowned self] in
                self.router?.sharing()
            }.disposed(by: disposeBag)

        checkInButton
            .rx
            .tap
            .bind { [unowned self] in
                self.userController = UserController()
                self.setupUserController()
                self.router?.checkIn()
        }.disposed(by: disposeBag)
    }

    func setupUserController() {
        userController.completion = { [weak self] data in
            if data != nil {
                self?.interactor?.postCheckIn(userInfo: data)
            }
        }
    }

}

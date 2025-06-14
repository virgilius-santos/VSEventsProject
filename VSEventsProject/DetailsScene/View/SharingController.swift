//
//  SharingController.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class SharingController {

    var activityVC: UIActivityViewController

    init(viewController: ShowDetailsViewController?) {
        var activityItems = [Any]()

        if let data = viewController?.titleLabel.text {
            activityItems.append(data)
        }

        if let data = viewController?.priceLabel.text {
            activityItems.append(data)
        }

        if let data = viewController?.dateLabel.text {
            activityItems.append(data)
        }

        if let data = viewController?.eventPoster.image {
            activityItems.append(data)
        }

        activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = viewController?.view
    }
}

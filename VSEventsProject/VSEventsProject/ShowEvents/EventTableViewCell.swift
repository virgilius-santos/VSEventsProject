//
//  EventTableViewCell.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImageView: UIImageView!

    @IBOutlet weak var eventLabel: UILabel!

    var viewModel: EventCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        eventLabel?.text = viewModel?.title
        if let url = viewModel?.imageUrl {
            eventImageView.getImage(withURL: url)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        eventImageView.af_cancelImageRequest()
    }
}

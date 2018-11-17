//
//  PersonCollectionViewCell.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    var viewModel: PersonCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        nameLabel?.text = viewModel?.title
        if let url = viewModel?.imageUrl {
            photoImageView.getImage(withURL: url)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.af_cancelImageRequest()
    }
}

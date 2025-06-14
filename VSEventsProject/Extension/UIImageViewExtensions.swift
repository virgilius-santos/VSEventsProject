//
//  ImageAPI.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 16/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {

    func getImage(withURL url: URL) {

        let downloader = ImageDownloader.default

        if let image = downloader.imageCache?.image(withIdentifier: url.absoluteString) {
            self.image = image
            return
        }

        let placeholder = UIImage(named: "placeholder")

        self.af_setImage(withURL: url, placeholderImage: placeholder, completion: { dataResponse in
            
            if let image = dataResponse.result.value {
                downloader.imageCache?.add(image, withIdentifier: url.absoluteString)
            }
        })
    }

}

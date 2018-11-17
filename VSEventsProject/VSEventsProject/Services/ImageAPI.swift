//
//  ImageAPI.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 16/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import RxAlamofire

extension UIImageView {

    func getImage(withURL url: URL) {

        if let image = ImageDownloader.default.imageCache?.image(withIdentifier: url.absoluteString) {
            self.image = image
            return
        }

        let placeholder = UIImage(named: "placeholder")
        self.rx.base.af_setImage(withURL: url, placeholderImage: placeholder) {
            dataResponse in

            if let image = dataResponse.result.value {
                ImageDownloader.default.imageCache?.add(image, withIdentifier: url.absoluteString)
            }
        }
    }

}

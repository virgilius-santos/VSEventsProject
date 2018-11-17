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
        self.rx.base.af_setImage(withURL: url)
    }

}

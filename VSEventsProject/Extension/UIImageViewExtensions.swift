import UIKit
import AlamofireImage
import RxSwift
import RxCocoa

extension UIImageView {
    var imageLoader: Binder<URL?> {
        .init(self) { imageView, url in
            imageView.getImage(withURL:url)
        }
    }

    func getImage(withURL url: URL?) {
        guard let url = url else { return }
        
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

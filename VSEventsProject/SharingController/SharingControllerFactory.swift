import UIKit

final class SharingControllerFactory {
    func make(shareData: ShowDetailsShareData) -> UIViewController {
        let activityVC: UIActivityViewController
        var activityItems = [Any]()

        if let data = shareData.title {
            activityItems.append(data)
        }

        if let data = shareData.price {
            activityItems.append(data)
        }

        if let data = shareData.date {
            activityItems.append(data)
        }

        if let data = shareData.poster {
            activityItems.append(data)
        }

        activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityVC
    }
}

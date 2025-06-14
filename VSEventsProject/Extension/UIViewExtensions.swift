import UIKit

extension UIView {

    private var backGrounViewTag: Int { return 3432 }

    func lock() {
        if viewWithTag(backGrounViewTag) != nil {
            return
        }

        let backGrounView = UIView()
        backGrounView.tag = backGrounViewTag
        backGrounView.alpha = 0

        addSubview(backGrounView)
        backGrounView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        backGrounView.translatesAutoresizingMaskIntoConstraints = false

        let descHorizontal = "H:|-0-[backGrounView]-0-|"
        let descVertical = "V:|-0-[backGrounView]-0-|"

        let viewsDict = ["backGrounView": backGrounView]

        let horizontalConstraint  = NSLayoutConstraint.constraints(
            withVisualFormat: descHorizontal,
            options: .init(rawValue: 0),
            metrics: nil,
            views: viewsDict
        )

        let verticalConstraint  = NSLayoutConstraint.constraints(
            withVisualFormat: descVertical,
            options: .init(rawValue: 0),
            metrics: nil,
            views: viewsDict
        )

        addConstraints(horizontalConstraint)
        addConstraints(verticalConstraint)

        let activityIndicator = UIActivityIndicatorView(style: .white)

        backGrounView.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        let centerHorizontally = NSLayoutConstraint(
            item: activityIndicator,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: backGrounView,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0
        )

        let centerVertically = NSLayoutConstraint(
            item: activityIndicator,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: backGrounView,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0
        )

        backGrounView.addConstraints([centerHorizontally, centerVertically])

        UIView.animate(
            withDuration: 0.3,
            animations: { backGrounView.alpha = 1 },
            completion: { _ in activityIndicator.startAnimating() }
        )
    }

    func unlock() {
        guard let backGroundView = self.viewWithTag(backGrounViewTag) else {
            return
        }
        UIView.animate(
            withDuration: 0.3,
            animations: { backGroundView.alpha = 0 },
            completion: { _ in backGroundView.removeFromSuperview() }
        )
    }
}

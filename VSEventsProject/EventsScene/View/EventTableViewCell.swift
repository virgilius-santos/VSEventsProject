import UIKit

final class EventTableViewCell: UITableViewCell {
    static let cellIdentifier = String(describing: EventTableViewCell.self)
    
    @IBOutlet weak var eventImageView: UIImageView!

    @IBOutlet weak var eventLabel: UILabel!

    var viewModel: EventCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        selectionStyle = .none
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

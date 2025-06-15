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
        eventImageView.getImage(withURL: viewModel?.imageUrl)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        eventImageView.af_cancelImageRequest()
    }
}

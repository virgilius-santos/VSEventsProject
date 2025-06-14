import UIKit

final class PersonCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = String(describing: PersonCollectionViewCell.self)

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    var viewModel: PersonCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        nameLabel?.text = viewModel?.title
        photoImageView.getImage(withURL: viewModel?.imageUrl)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.af_cancelImageRequest()
    }
}

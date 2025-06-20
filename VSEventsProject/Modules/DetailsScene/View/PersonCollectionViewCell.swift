import UIKit
import AlamofireImage

final class PersonCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = String(describing: PersonCollectionViewCell.self)

    private let photoImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.layer.cornerRadius = 30
       imageView.clipsToBounds = true
       imageView.contentMode = .scaleAspectFill
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
       }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backgroundCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundCardView)
        backgroundCardView.addSubview(photoImageView)
        backgroundCardView.addSubview(nameLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var viewModel: PersonCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        nameLabel.text = viewModel?.title
        photoImageView.getImage(withURL: viewModel?.imageUrl)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.af_cancelImageRequest()
    }
    
    func configure(with viewModel: MockPersonCellViewModel) {
        nameLabel.text = viewModel.title

        if let url = viewModel.imageUrl {
            // Carrega imagem manualmente com URLSession
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.photoImageView.image = image
                    }
                }
            }.resume()
        } else {
            if #available(iOS 13.0, *) {
                self.photoImageView.image = UIImage(systemName: "person.crop.circle.fill")
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

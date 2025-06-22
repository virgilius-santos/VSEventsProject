import UIKit
import AlamofireImage

final class EventTableViewCell: UITableViewCell {
    static let cellIdentifier = String(describing: EventTableViewCell.self)
    
    let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let eventLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var viewModel: EventCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupViews()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: - Setup
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .cyan
        
        contentView.addSubview(eventImageView)
        contentView.addSubview(eventLabel)
        
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        eventLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 60),
            eventImageView.heightAnchor.constraint(equalToConstant: 60),
            
            eventLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 12),
            eventLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            eventLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    //MARK: - Bind

    private func bindViewModel() {
        selectionStyle = .none
        eventLabel.text = viewModel?.title
        eventImageView.getImage(withURL: viewModel?.imageUrl)
        
        if let url = viewModel?.imageUrl {
            eventImageView.af_setImage(withURL: url)
        } else {
            eventImageView.image = nil
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        eventImageView.af_cancelImageRequest()
        eventImageView.image = nil
        eventLabel.text = nil
    }
}

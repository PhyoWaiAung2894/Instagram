//
//  UserFollowTableViewCell.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/28/24.
//

import UIKit

protocol UserFollowTableViewCellDelegate: AnyObject {
    func didTapFollowUnFollowButton(model: UserRelationShip)
}

enum FollowState {
    case following, notFollowing
}

struct UserRelationShip {
    let username : String
    let userProfilePhoto: URL
    let name : String
    let type: FollowState
}

class UserFollowTableViewCell: UITableViewCell {
    
    static let identifier = "UserFollowTableViewCell"
    
    public weak var delegate : UserFollowTableViewCellDelegate?
    
    private var model : UserRelationShip?
    private let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Michel"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let userNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Tommy"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let followButton : UIButton = {
        
        let button = UIButton()
        button.backgroundColor = .link
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(followButton)
        
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    }
    
    @objc private func didTapFollowButton() {
        guard let model = model else { return }
        delegate?.didTapFollowUnFollowButton(model: model)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        userNameLabel.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.layer.borderWidth = 0
        followButton.backgroundColor = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectionStyle = .none
        profileImageView.frame = CGRect(x: 3,
                                        y: 3,
                                        width: contentView.height-6,
                                        height: contentView.height-6)
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        let buttonWidth = contentView.width > 500 ? 220.0 : contentView.width/3
        followButton.frame = CGRect(x: contentView.width-5-buttonWidth,
                                    y: (contentView.height-40)/2,
                                    width: buttonWidth,
                                    height: 40)
        
        let labelHeight = contentView.height/2
        nameLabel.frame = CGRect(x: profileImageView.right + 5,
                                 y: 0,
                                 width: contentView.width-8-profileImageView.width-buttonWidth,
                                 height: labelHeight)
        
        userNameLabel.frame = CGRect(x: profileImageView.right+5,
                                     y: nameLabel.bottom,
                                     width: contentView.width-8-profileImageView.width-userNameLabel.width-buttonWidth,
                                     height: labelHeight)
    }
    
    public func configure(with model: UserRelationShip) {
        
        self.model = model
        nameLabel.text = model.name
        userNameLabel.text = model.username
        profileImageView.sd_setImage(with: model.userProfilePhoto)
        
        switch model.type {
        case .following:
            followButton.setTitle("Unfollow", for: .normal)
            followButton.setTitleColor(.label, for: .normal)
            followButton.backgroundColor = .systemBackground
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.label.cgColor
        case .notFollowing:
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = .link
            followButton.layer.borderWidth = 0
            followButton.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

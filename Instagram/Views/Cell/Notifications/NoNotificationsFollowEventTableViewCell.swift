//
//  NoNotificationsFollowEventTableViewCell.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/30/24.
//

import UIKit

protocol NoNotificationsFollowEventTableViewCellDelegate : AnyObject {
    func didTapFollowUnFollowButton(model : UserNotification)
}

class NoNotificationsFollowEventTableViewCell: UITableViewCell {

    static let identifier = "NoNotificationsFollowEventTableViewCell"
    
    private var model : UserNotification?
    
    public weak var delegate : NoNotificationsFollowEventTableViewCellDelegate?
    
    private let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "Joker started following you."
        return label
    }()
    
    private let followButton : UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        configureForFollowButton()
        selectionStyle = .none
    }
    
    @objc private func didTapFollowButton() {
        guard let model = model else { return }
        delegate?.didTapFollowUnFollowButton(model: model)
    }
    
    public func configure(with model : UserNotification) {
        self.model = model
        
        switch model.type {
        case .like(_):
            break
        case .follow(let state):
            switch state {
            case .following:
                configureForFollowButton()
            case .notFollowing:
                followButton.setTitle("Follow", for: .normal)
                followButton.setTitleColor(.white, for: .normal)
                followButton.layer.borderWidth = 0
                followButton.layer.borderColor = UIColor.secondaryLabel.cgColor
                followButton.backgroundColor = .link
            }
        }
        
        label.text = model.text
        profileImageView.sd_setImage(with: model.user.profilePhoto)
    }
    
    private func configureForFollowButton() {
        followButton.setTitle("Unfollow", for: .normal)
        followButton.setTitleColor(.label, for: .normal)
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        followButton.setTitle(nil, for: .normal)
        followButton.backgroundColor = nil
        followButton.layer.borderWidth = 0
        label.text = nil
        profileImageView.image = nil
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3,
                                        y: 3,
                                        width: contentView.height-6,
                                        height: contentView.height-6)
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        let size:CGFloat = 100
        followButton.frame = CGRect(x: contentView.width-5-size,
                                  y: 0,
                                  width: size,
                                  height: 44)
        label.frame = CGRect(x: profileImageView.right+5,
                             y: 0,
                             width: contentView.width-size-profileImageView.width-11,
                             height: contentView.height)
    }
}

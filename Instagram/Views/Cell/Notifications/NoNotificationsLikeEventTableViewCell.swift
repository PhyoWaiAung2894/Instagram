//
//  NoNotificationsLikeEventTableViewCell.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/30/24.
//

import UIKit
import SDWebImage

protocol NoNotificationsLikeEventTableViewCellDelegate : AnyObject {
    func didTapRelatedPostButton(model : UserNotification)
}

class NoNotificationsLikeEventTableViewCell: UITableViewCell {

    static let identifier = "NoNotificationsLikeEventTableViewCell"
    
    public weak var delegate : NoNotificationsLikeEventTableViewCellDelegate?
    
    private var model : UserNotification?
    
    private let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "@HugeJack like your post"
        return label
    }()
    
    private let postButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
        contentView.addSubview(postButton)
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        selectionStyle = .none
    }
    
    
    public func configure(with model : UserNotification) {
        self.model = model
        
        switch model.type {
        case .like(let post):
            let thumbNailImage = post.thumbNailImage
            guard !thumbNailImage.absoluteString.contains("google.com") else {
                return
            }
            postButton.sd_setBackgroundImage(with: thumbNailImage, for: .normal)
        case .follow:
            break
        }
        
        label.text = model.text
        profileImageView.sd_setImage(with: model.user.profilePhoto)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        postButton.setTitle(nil, for: .normal)
        label.text = nil
        profileImageView.image = nil
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3,
                                        y: 3,
                                        width: contentView.height-6,
                                        height: contentView.height-6)
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        let size = contentView.height-4
        postButton.frame = CGRect(x: contentView.width-size,
                                  y: 0,
                                  width: size,
                                  height: size)
        
        label.frame = CGRect(x: profileImageView.right+5,
                             y: 0,
                             width: contentView.width-size-profileImageView.width-11,
                             height: contentView.height)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     @objc private func didTapPostButton() {
        
        guard let model = model else { return }
        delegate?.didTapRelatedPostButton(model: model)
    }
}

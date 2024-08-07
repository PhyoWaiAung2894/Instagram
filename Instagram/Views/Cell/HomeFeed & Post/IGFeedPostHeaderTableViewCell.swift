//
//  IGFeedPostHeaderTableViewCell.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/19/24.
//

import UIKit
import SDWebImage

protocol IGFeedPostHeaderTableViewCellDelegate : AnyObject {
    func didTapMoreButton()
}
class IGFeedPostHeaderTableViewCell: UITableViewCell {


    static let identifier = "IGFeedPostHeaderTableViewCell"
    
    weak var delegate : IGFeedPostHeaderTableViewCellDelegate?
    
    private let profilePhotoImageView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let userNameLabel : UILabel = {
        
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
        
    }()
    
    private let moreButton : UIButton = {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profilePhotoImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(moreButton)
        
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
    }
    
    @objc private func didTapMoreButton() {
        delegate?.didTapMoreButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        let size = contentView.height - 4
        
        profilePhotoImageView.frame = CGRect(x: 2,
                                             y: 2,
                                             width: size,
                                             height: size)
        profilePhotoImageView.layer.cornerRadius = size/2
        
        moreButton.frame = CGRect(x: contentView.width-size,
                                             y: 2,
                                             width: size,
                                             height: size)
        
        userNameLabel.frame = CGRect(x: profilePhotoImageView.right+10,
                                     y: 2,
                                     width: contentView.width-(size*2)-15,
                                     height: contentView.height-4)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = nil
        profilePhotoImageView.image = nil
    }
    
    public func configure(with post: User){
        
        userNameLabel.text = post.username
//        profilePhotoImageView.image = UIImage(systemName: post.profilePhoto)
        
        profilePhotoImageView.sd_setImage(with: post.profilePhoto)
        
    }

    
}

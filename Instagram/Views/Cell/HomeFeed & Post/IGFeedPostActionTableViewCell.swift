//
//  IGFeedPostActionTableViewCell.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/19/24.
//

import UIKit

protocol IGFeedPostActionTableViewCellDelegate : AnyObject {
    func tapLikeButton()
    func tapCommentButton()
    func tapSendButton()
}

class IGFeedPostActionTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostActionTableViewCell"
    
    weak var delegate : IGFeedPostActionTableViewCellDelegate?
    
    private let likeButton : UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let commentButton : UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "message", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let sendButton : UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "paperplane", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(sendButton)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(didTapSendButtton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapLikeButton() {
        delegate?.tapLikeButton()
    }
    
    @objc private func didTapCommentButton() {
        delegate?.tapCommentButton()
    }
    
    @objc private func didTapSendButtton() {
        delegate?.tapCommentButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonSize = contentView.height-10
        
        let buttons = [likeButton,commentButton,sendButton]
        
        for (index,button) in buttons.enumerated() {
            button.frame = CGRect(x:  (CGFloat(index)*buttonSize) + (10*CGFloat(index)),
                             y: 5,
                             width: buttonSize,
                             height: buttonSize)
        }
    }
    
    public func configure(){
        
    }

}

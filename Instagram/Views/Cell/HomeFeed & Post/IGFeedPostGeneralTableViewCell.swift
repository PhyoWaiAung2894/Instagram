//
//  IGFeedPostGeneralTableViewCell.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/19/24.
//

import UIKit

class IGFeedPostGeneralTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostGeneralTableViewCell"
    
    private let userName : UILabel = {
        
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let commentsText : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userName)
        contentView.addSubview(commentsText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        userName.frame = CGRect(x: 5,
                                y: 0,
                                width: contentView.width-10,
                                height: contentView.height/2)
        commentsText.frame = CGRect(x: 5,
                                    y: userName.bottom,
                                    width: contentView.width-10,
                                    height: contentView.height/2)
    }
    
    public func configure(model: PostComment){
        
        userName.text = model.username
        commentsText.text = model.text
        
    }

}

//
//  NoNotificationsView.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/30/24.
//

import UIKit

class NoNotificationsView: UIView {
    
    private let label : UILabel = {
        let label = UILabel()
        label.text = "No New Notifications Yet"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "bell")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: (width-50)/2,
                                 y: 0,
                                 width: 50,
                                 height: 50)
        
        label.frame = CGRect(x: 0,
                             y: imageView.bottom,
                             width: width,
                             height: height-50)
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//
//  IGFeedPostTableViewCell.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/19/24.
//

import UIKit
import SDWebImage
import AVFoundation

final class IGFeedPostTableViewCell: UITableViewCell {
    
    static let identifier = "IGFeedPostTableViewCell"
    
    private let postImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = nil
        image.clipsToBounds = true
        return image
    }()
    
    private var player: AVPlayer?
    private var playerLayer = AVPlayerLayer()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layer.addSublayer(playerLayer)
        contentView.addSubview(postImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        playerLayer.frame = contentView.bounds
        postImage.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImage.image = nil
    }
    
    public func configure(with post: UserPost) {
        
//        postImage.image = UIImage(named: "test")
//        
//        return
        
        switch post.postType {
            
        case .photo:
            
            postImage.sd_setImage(with: post.postURL)
            
        case .video:
            
            player = AVPlayer(url: post.postURL)
            playerLayer.player = player
            playerLayer.player?.volume = 0
            playerLayer.player?.play()
        }
        
    }
    
}

//
//  ProfileInfoHeaderCollectionReusableView.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/21/24.
//

import UIKit

protocol ProfileInfoHeaderCollectionReusableViewDelegate : AnyObject {
    
    func profileHeaderDidTapPostButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowerButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView)
}

class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "ProfileInfoHeaderCollectionResuableView"
    
    public weak var delegate : ProfileInfoHeaderCollectionReusableViewDelegate?
    
    private let profilePhotoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "batman1")
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let postButtons : UIButton = {
        
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let followingButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("Following", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let followerButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("Follower", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let editProfileButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("Edit Your Profile", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let nameLabel : UILabel = {
        
        let label = UILabel()
        label.text = "Bruce Wayne"
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let bioLabel : UILabel = {
        
        let label = UILabel()
        label.text = "A crimefighter operating in Gotham City, I serve as its protector, using the symbol of a bat to strike fear into the hearts of criminals. "
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        addButtonFunctions()
        backgroundColor = .systemBackground
        clipsToBounds = true
        
    }
    
    private func configure(model: String){
        profilePhotoImageView.image = UIImage(named: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let profilePhotoSize = width/4
        profilePhotoImageView.frame = CGRect(
            x: 5,
            y: 5,
            width: profilePhotoSize,
            height: profilePhotoSize
        ).integral
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2.0
        
        let buttonHeight = profilePhotoSize/2
        let countButtonWidth = (width-10-profilePhotoSize)/3
        
        postButtons.frame = CGRect(
            x: profilePhotoImageView.right+5,
            y: 5,
            width: countButtonWidth - 5,
            height: buttonHeight
        ).integral
        
        followerButton.frame = CGRect(
            x: postButtons.right+5,
            y: 5,
            width: countButtonWidth - 5,
            height: buttonHeight
        ).integral
        
        followingButton.frame = CGRect(
            x: followerButton.right+5,
            y: 5,
            width: countButtonWidth - 5,
            height: buttonHeight
        ).integral
        
        editProfileButton.frame = CGRect(
            x: profilePhotoImageView.right+5,
            y: 10 + buttonHeight,
            width: countButtonWidth * 3,
            height: buttonHeight
        ).integral
        
        nameLabel.frame = CGRect(
            x: 5,
            y: profilePhotoImageView.bottom + 5,
            width: width - 10,
            height: 50
        ).integral
        
        let bioLabelSize = bioLabel.sizeThatFits(frame.size)
        
        bioLabel.frame = CGRect(
            x: 5,
            y: 5 + nameLabel.bottom,
            width: width - 10,
            height: bioLabelSize.height
        ).integral
        
    }
    
    func addSubViews() {
        addSubview(profilePhotoImageView)
        addSubview(postButtons)
        addSubview(followerButton)
        addSubview(followingButton)
        addSubview(editProfileButton)
        addSubview(nameLabel)
        addSubview(bioLabel)
        
    }
    
    func addButtonFunctions() {
        followerButton.addTarget(self, action: #selector(didTapFollowerButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingrButton), for: .touchUpInside)
        postButtons.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
    }
    
    //MARK: - ButtonActions
    
    @objc func didTapFollowerButton() {
        delegate?.profileHeaderDidTapFollowerButton(self)
    }
    
    @objc func didTapFollowingrButton() {
        delegate?.profileHeaderDidTapFollowingButton(self)
    }
    
    @objc func didTapPostButton() {
        delegate?.profileHeaderDidTapPostButton(self)
    }
    
    @objc func didTapEditProfileButton() {
        delegate?.profileHeaderDidTapEditProfileButton(self)
    }

}

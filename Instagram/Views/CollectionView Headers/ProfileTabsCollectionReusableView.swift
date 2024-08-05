//
//  ProfileTabsCollectionReusableView.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/21/24.
//

import UIKit

protocol ProfileTabsCollectionReusableDelegate : AnyObject {
    func didTApGridButton()
    func didTapTaggedButton()
}

class ProfileTabsCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "ProfileTabsCollectionReusableView"
    
    public weak var delegate : ProfileTabsCollectionReusableDelegate?
    
    struct Constants {
        static let padding: CGFloat = 2
    }
    
    private let gridButton : UIButton = {
        let button = UIButton()
        button.tintColor = .systemBlue
        button.setBackgroundImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        return button
    }()
    
    private let taggedButton : UIButton = {
        let button = UIButton()
        button.tintColor = .lightGray
        button.setImage(UIImage(systemName: "tag"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(gridButton)
        addSubview(taggedButton)
        
        gridButton.addTarget(self, action: #selector(didTApGridButton), for: .touchUpInside)
        taggedButton.addTarget(self, action: #selector(didTapTaggedButton), for: .touchUpInside)
    }
    
    @objc func didTApGridButton(){
        
        gridButton.tintColor = .systemBlue
        taggedButton.tintColor = .lightGray
        delegate?.didTApGridButton()
    }
    
    @objc func didTapTaggedButton(){
       
        gridButton.tintColor = .lightGray
        taggedButton.tintColor = .systemBlue
        delegate?.didTapTaggedButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = height - (Constants.padding * 2)
        let gridButtonX = ((width/2)-size)/2
        gridButton.frame = CGRect(x: gridButtonX,
                                    y: 2,
                                    width: size,
                                    height: size)
        
        taggedButton.frame = CGRect(x: gridButtonX + (width/2),
                                    y: 2,
                                    width: size,
                                    height: size)
        
    }
}

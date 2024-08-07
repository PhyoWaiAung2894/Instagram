//
//  ProfileViewController.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/12/24.
//

import UIKit

//MARK: - Profile View Controller

final class ProfileViewController: UIViewController {
    
    private var collectionView : UICollectionView?
    
    private var userPosts = [UserPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMockData()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let size = (view.width - 4)/3
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //Cell
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        //Header
        collectionView?.register(ProfileInfoHeaderCollectionReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        
        collectionView?.register(ProfileTabsCollectionReusableView.self.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileTabsCollectionReusableView.identifier)
        
        collectionView?.backgroundColor = .systemBackground
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
    }
    
    private func createMockData() {
        
        userPosts.removeAll()
        
        let usernames = ["Clark Kent", "Diana Prince", "Barry Allen", "Hal Jordan"]
   
        let postsURL = [
            "https://images7.alphacoders.com/134/thumb-1920-1340753.png",
            "https://wallpapers-clan.com/wp-content/uploads/2023/11/dc-aesthetic-batman-red-desktop-wallpaper-preview.jpg",
            "https://mfiles.alphacoders.com/100/thumb-350-1008719.png",
            "https://mfiles.alphacoders.com/100/thumb-350-1008720.png",
            "https://mfiles.alphacoders.com/100/thumb-350-1008721.png"
        ]
        
        let usercomments = [
        "Woo Nice Post",
        "You Look Great",
        "Nice Picture",
        "That's our sir bat"
        ]
        
        for i in 0..<usernames.count {
            
            var comments = [PostComment]()
            for x in 0...1 {
                comments.append(PostComment(identifier: "123_\(x)", username: "@\(usernames.randomElement() ?? "Hero")", text: "\(usercomments.randomElement() ?? "Hero")", createdDate: "12-\(x)-2024", likeCount: []))
            }
            
            let user = User(username: "Bruce Wayne", profilePhoto: URL(string: "https://static.wikia.nocookie.net/dc-abridged/images/5/5e/BruceWayne001.png/revision/latest/scale-to-width-down/1000?cb=20200507041747")!, bio: "", name: (first: "", last: ""), birthDate: Date(), gender: .male, counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
            
            let post = UserPost(postType: .photo, thumbNailImage: URL(string: "\(postsURL[i])")!, postURL: URL(string: "\(postsURL[i])")!, caption: nil, likeCount: [], comments: comments, createdDate: Date(), taggedUsers: [], owner: user)
            
            userPosts.append(post)
        }
    }
    
    private func configureNavigationBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingButton))
    }
    
    @objc private func didTapSettingButton(){
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

//MARK: - UICollectionView Delegate

extension ProfileViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionView DataSource

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        }
        
        return userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let model = userPosts[indexPath.row]
      
        let vc = PostViewController(model: model)
        vc.title = model.postType.rawValue
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

//MARK: - UICollectionView FlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  model = userPosts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.backgroundColor = .systemBlue
        cell.configure(with: model)
//        cell.configure(debug: "test")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else { 
            //footer
            return UICollectionReusableView()
        }
        
        if indexPath.section == 1 {
            //tabs header
            let tapControlHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileTabsCollectionReusableView.identifier, for: indexPath) as! ProfileTabsCollectionReusableView
            
            tapControlHeader.delegate = self
            return tapControlHeader
        }
        
        let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileInfoHeaderCollectionReusableView
        
        profileHeader.delegate = self
        return profileHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize(width: collectionView.width, height: collectionView.height/3)
        }
        
        //Size of section tabs
        return CGSize(width: collectionView.width, height: 50)
    }
}

//MARK: - ProfileInfoHeaderCollectionReusableViewDelegate

extension ProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate {
    func profileHeaderDidTapPostButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        
        //scroll to the posts
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
    }
    
    func profileHeaderDidTapFollowerButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        
        var mockData = [UserRelationShip]()
        let usernames = ["Clark Kent", "Diana Prince", "Barry Allen", "Hal Jordan"]
        
        let profilePhotos = [
            
            "https://static.wikia.nocookie.net/superman/images/0/0a/Clarkkent-secretorigin.jpg/revision/latest?cb=20100916050519",
            "https://static.wikia.nocookie.net/dcmovies/images/b/b1/Wonder_Woman_DCAU.png/revision/latest?cb=20190515014353",
            "https://static.wikia.nocookie.net/heroes-and-villain/images/4/40/Barry_Allen_Earth-16_0003.png/revision/latest?cb=20220623161239",
            "https://static.wikia.nocookie.net/dcanimated/images/7/7b/Hal_Jordan.png/revision/latest?cb=20180708123731"
        ]
        for x in 0..<usernames.count {
            mockData.append(UserRelationShip(username: usernames[x], userProfilePhoto: URL(string: profilePhotos[x])!, name: usernames[x], type: x % 2 == 0 ? .following : .notFollowing))
        }
        
        let vc = ListsViewController(data: mockData)
        vc.title = "Followers"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        
        var mockData = [UserRelationShip]()
        let usernames = ["Clark Kent", "Diana Prince", "Barry Allen", "Hal Jordan"]
        
        let profilePhotos = [
            
            "https://static.wikia.nocookie.net/superman/images/0/0a/Clarkkent-secretorigin.jpg/revision/latest?cb=20100916050519",
            "https://static.wikia.nocookie.net/dcmovies/images/b/b1/Wonder_Woman_DCAU.png/revision/latest?cb=20190515014353",
            "https://static.wikia.nocookie.net/heroes-and-villain/images/4/40/Barry_Allen_Earth-16_0003.png/revision/latest?cb=20220623161239",
            "https://static.wikia.nocookie.net/dcanimated/images/7/7b/Hal_Jordan.png/revision/latest?cb=20180708123731"
        ]
        for x in 0..<usernames.count {
            mockData.append(UserRelationShip(username: usernames[x], userProfilePhoto: URL(string:  profilePhotos[x])!, name: usernames[x], type: x % 2 == 0 ? .following : .notFollowing))
        }
        
        let vc = ListsViewController(data: mockData)
        vc.title = "Following"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        present(UINavigationController(rootViewController: vc),animated: true)
    }
    
    
}

//MARK: - Header Section

extension ProfileViewController: ProfileTabsCollectionReusableDelegate {
    
    func didTApGridButton() {
        //Reload CollectionView with data
    }
    
    func didTapTaggedButton() {
        //Reload CollectionView with data
    }
    
    
}


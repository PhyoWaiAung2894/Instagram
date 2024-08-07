//
//  ExploreViewController.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/11/24.
//

import UIKit

class ExploreViewController: UIViewController {

    private let searchBar : UISearchBar = {
        
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search"
        searchbar.backgroundColor = .secondarySystemBackground
        
        return searchbar
    }()
    
    private var models = [UserPost]()
    
    private var filteredModels = [UserPost]()
    
    private var isSearching = false
    
    private var collectionView : UICollectionView?
    
    private var tabbedSearchCollectionView: UICollectionView?
    
    private let dimmedView : UIView = {
        
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureSearchBarView()
        
        configureExploreCollectionView()
        
        configureDimmedView()
        
        configureTabbedSearch()
        
        createMockData()
    }
    
    private func createMockData() {
        
        models.removeAll()
        
        let usernames = ["Bruce Wayne", "Clark Kent", "Diana Prince", "Barry Allen", "Hal Jordan"]
        let profilePhotos = [
            "https://static.wikia.nocookie.net/dc-abridged/images/5/5e/BruceWayne001.png/revision/latest/scale-to-width-down/1000?cb=20200507041747",
            "https://static.wikia.nocookie.net/superman/images/0/0a/Clarkkent-secretorigin.jpg/revision/latest?cb=20100916050519",
            "https://static.wikia.nocookie.net/dcmovies/images/b/b1/Wonder_Woman_DCAU.png/revision/latest?cb=20190515014353",
            "https://static.wikia.nocookie.net/heroes-and-villain/images/4/40/Barry_Allen_Earth-16_0003.png/revision/latest?cb=20220623161239",
            "https://static.wikia.nocookie.net/dcanimated/images/7/7b/Hal_Jordan.png/revision/latest?cb=20180708123731"
        ]
        
        let postsURL = [
            "https://images7.alphacoders.com/134/thumb-1920-1340753.png",
            "https://www.chromethemer.com/wallpapers/chromebook-wallpapers/images/960/superman-chromebook-wallpaper.jpg",
            "https://birchtree.me/wp-content/uploads/2017/03/wonder-woman.jpg",
            "https://images6.alphacoders.com/133/thumb-1920-1330136.png",
            "https://wallpapercat.com/w/middle-retina/f/0/1/10769-3840x2160-desktop-4k-green-lantern-wallpaper.jpg"
        ]
        
        let usercomments = [
        "Woo Nice Post",
        "You Look Great",
        "Nice Picture"
        ]
        
        for i in 0..<usernames.count {
            
            var comments = [PostComment]()
            for x in 0...1 {
                comments.append(PostComment(identifier: "123_\(x)", username: "@\(usernames.randomElement() ?? "Hero")", text: "\(usercomments.randomElement() ?? "Hero")", createdDate: "12-\(x)-2024", likeCount: []))
            }
            
            let user = User(username: "\(usernames[i])", profilePhoto: URL(string: "\(profilePhotos[i])")!, bio: "", name: (first: "", last: ""), birthDate: Date(), gender: .male, counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
            
            let post = UserPost(postType: .photo, thumbNailImage: URL(string: "\(postsURL[i])")!, postURL: URL(string: "\(postsURL[i])")!, caption: nil, likeCount: [], comments: comments, createdDate: Date(), taggedUsers: [], owner: user)
            
            models.append(post)
        }
    }
    
    private func configureExploreCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (view.width-4)/3, height: (view.width-4)/3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
    }
    
    private func configureSearchBarView() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureDimmedView() {
        view.addSubview(dimmedView)
        
        let getsure = UITapGestureRecognizer(target: self, action: #selector(didCancleSearch))
        getsure.numberOfTouchesRequired = 1
        getsure.numberOfTapsRequired = 1
        dimmedView.addGestureRecognizer(getsure)
    }
    
    private func configureTabbedSearch() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width/3, height: 52)
        layout.scrollDirection = .horizontal
        tabbedSearchCollectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        tabbedSearchCollectionView?.backgroundColor = .yellow
        tabbedSearchCollectionView?.isHidden = true
        guard let tabbedSearchCollectionView = tabbedSearchCollectionView else {
            return
        }
        tabbedSearchCollectionView.delegate = self
        tabbedSearchCollectionView.dataSource = self
        view.addSubview(tabbedSearchCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        dimmedView.frame = view.bounds
        tabbedSearchCollectionView?.frame = CGRect(x: 0, y: additionalSafeAreaInsets.top, width: view.width, height: 72)
    }
  
}

//MARK: - CollectionView Delegate

extension ExploreViewController: UICollectionViewDelegate {
    
}

//MARK: - CollectionView DataSource

extension ExploreViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == tabbedSearchCollectionView {
            return 0
        }
        return isSearching ? filteredModels.count : models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = PostViewController(model: models[indexPath.row])
        vc.title = models[indexPath.row].postType.rawValue
        navigationController?.pushViewController(vc , animated: true)
    }
}

//MARK: - CollectionViewDelegate FlowLayout
extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == tabbedSearchCollectionView {
            return UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
               
        let model = isSearching ? filteredModels[indexPath.row] : models[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

//MARK: - SearchBar Delegate

extension ExploreViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        didCancleSearch()
        query(text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancleSearch))
        
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0.4
        }){ done in
            if done {
                self.tabbedSearchCollectionView?.isHidden = false
            }
        }
    }
    
    @objc func didCancleSearch() {
        searchBar.text = ""
        query("")
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        self.tabbedSearchCollectionView?.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0
        }) { done in
            if done {
                self.dimmedView.isHidden = true
            }
        }
    }
    
    func query(_ text: String) {
        if text.isEmpty {
            isSearching = false
            filteredModels.removeAll()
        } else {
            isSearching = true
            filteredModels = models.filter { $0.owner.username.lowercased().contains(text.lowercased()) }
        }
        collectionView!.reloadData()
    }
    
}

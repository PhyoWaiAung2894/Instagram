//
//  ViewController.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/11/24.
//

import UIKit
import FirebaseAuth

struct HomeFeedRenderViewModel {
    let header : PostRenderViewModel
    let post : PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    private let tableView : UITableView = {
        
        let tableview = UITableView()
        tableview.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableview.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableview.register(IGFeedPostActionTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionTableViewCell.identifier)
        tableview.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        createMockData()
    }
    
    private func createMockData() {
        feedRenderModels.removeAll()
        
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
            for x in 0...2 {
                comments.append(PostComment(identifier: "123_\(x)", username: "@\(usernames.randomElement() ?? "Hero")", text: "\(usercomments.randomElement() ?? "Hero")", createdDate: "12-\(x)-2024", likeCount: []))
            }

            let user = User(username: "\(usernames[i])", profilePhoto: URL(string: "\(profilePhotos[i])")!, bio: "", name: (first: "", last: ""), birthDate: Date(), gender: .male, counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
            
            let post = UserPost(postType: .photo, thumbNailImage: URL(string: "https://www.google.com")!, postURL: URL(string: "\(postsURL[i])")!, caption: nil, likeCount: [], comments: comments, createdDate: Date(), taggedUsers: [], owner: user)
            
            let mockModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)),
                                                    post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                                                    actions: PostRenderViewModel(renderType: .actions(provider: "")),
                                                    comments: PostRenderViewModel(renderType: .comments(provider: comments)))
            
        
            feedRenderModels.append(mockModel)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .systemBackground
        handleNotAuthenticated()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    private func handleNotAuthenticated() {
        //Check auth status
        if Auth.auth().currentUser == nil {
            //Show log in
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }

}

//MARK: - UITableView Delegate

extension HomeViewController: UITableViewDelegate {
  
}

//MARK: - UITableView DataSource

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let model : HomeFeedRenderViewModel
        
        if section == 0 {
            
            model = feedRenderModels[0]
            
        }else {
            
            let position = section / 4
            model = feedRenderModels[position]
            
        }
        
        let subSection = section % 4
        
        if subSection == 0 {
            
            //header
            return 1
            
        }else if subSection == 1 {
            
            //Post
            return 1
            
        }else if subSection == 2{
            
            //Action
            return 1
            
        }else if subSection == 3 {
            
            //Comment
            let commentModel = model.comments
            switch commentModel.renderType {
           
            case .comments(let comments):
                return comments.count > 2 ? 2 : comments.count
            case .header(provider: _):
                return 0
            case .primaryContent(provider: _):
                return 0
            case .actions(provider: _):
                return 0
        
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let model : HomeFeedRenderViewModel
        if section == 0 {
            
            model = feedRenderModels[0]
            
        }else {
            
            let position = section % 4 == 0 ? section/4 : ((section - (section % 4))/4)
            model = feedRenderModels[position]
            
        }
        
        let subSection = section % 4
        
        if subSection == 0 {
            
            //header
            let headerModel = model.header
            
            switch headerModel.renderType {
                
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
                cell.delegate = self
                cell.configure(with: user)
                return cell
                
            case .primaryContent(provider: _):
                return UITableViewCell()
            case .actions(provider: _):
                return UITableViewCell()
            case .comments(provider: _):
                return UITableViewCell()
           
            }
            
        }else if subSection == 1 {
            
            //Post
            let postModel = model.post
            
            switch postModel.renderType {
            
            case .primaryContent(let post):
                
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
                cell.configure(with: post)
                return cell
            
            case .header(provider: _):
                return UITableViewCell()
            case .actions(provider: _):
                return UITableViewCell()
            case .comments(provider: _):
                return UITableViewCell()
              
            }
            
        }else if subSection == 2{
            
            //Action
            let actionsModel = model.actions
            
            switch actionsModel.renderType {
            
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionTableViewCell.identifier, for: indexPath) as! IGFeedPostActionTableViewCell
                cell.delegate = self
                return cell
                
            case .header(provider: _):
                return UITableViewCell()
            case .primaryContent(provider: _):
                return UITableViewCell()
            case .comments(provider: _):
                return UITableViewCell()
             
            }
        }
        else if subSection == 3 {
            
            //Comment
            //Comment
            let commentModel = model.comments
            switch commentModel.renderType {
           
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
                
                cell.configure(model: comments[indexPath.row])
                
                return cell
                
            case .header(provider: _):
                return UITableViewCell()
            case .primaryContent(provider: _):
                return UITableViewCell()
            case .actions(provider: _):
                return UITableViewCell()
          
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let subSection = indexPath.section % 4
        
        if subSection == 0 {
            
            //header
            return 70
            
        }else  if subSection == 1 {
            
            //Post
            return tableView.width
            
        }else if subSection == 2 {
            
            //Action
            return 60
            
        }else  if subSection == 3 {
            
            //Comments
            return 50
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let subSection = section % 4
        return subSection == 3 ? 30 : 0
    }
}

//MARK: - IGFeedPostHeaderTableViewCellDelegate

extension HomeViewController: IGFeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report Post", style: .destructive,handler: { [weak self] _ in
            self?.reportPost()
            
        }))
        present(actionSheet,animated: true)
    }
    
    func reportPost() {
        
    }
}

//MARK: - IGFeedPostActionTableViewCellDelegate

extension HomeViewController: IGFeedPostActionTableViewCellDelegate {
    func tapLikeButton() {
        print("Liked Post")
    }
    
    func tapCommentButton() {
        print("Comment")
    }
    
    func tapSendButton() {
        print("Send Message")
    }
    
    
}


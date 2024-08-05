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
        
        let user = User(username: "Bruce Wyne", profilePhoto: URL(string: "https://www.google.com")!, bio: "", name: (first: "",last: ""), birthDate: Date(), gender: .male, counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
        
        let post = UserPost(postType: .photo, thumbNailImage: URL(string: "https://www.google.com")!, postURL: URL(string: "https://www.google.com")!, caption: nil, likeCount: [], comments: [], createdDate: Date(), taggedUsers: [], owner: user)
        
        var comments = [PostComment]()
        for x in 0...2 {
            comments.append(PostComment(identifier: "123_\(x)", username: "@Wade Wilson \(x)", text: "You are fucking welcome", createdDate: "12-\(x)-2024", likeCount: []))
        }
        for _ in 0...5 {
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
                cell.configure(model: comments)
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


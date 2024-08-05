//
//  NotificationViewController.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/11/24.
//

import UIKit

enum UserNotificationType {
    case like(post: UserPost), follow(state : FollowState)
}
struct UserNotification {
    let type : UserNotificationType
    let text : String
    let user : User
}

class NotificationViewController: UIViewController {
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .systemBackground
        tableView.register(NoNotificationsLikeEventTableViewCell.self, forCellReuseIdentifier: NoNotificationsLikeEventTableViewCell.identifier)
        tableView.register(NoNotificationsFollowEventTableViewCell.self, forCellReuseIdentifier: NoNotificationsFollowEventTableViewCell.identifier)
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()

    private lazy var noNotificationsView = NoNotificationsView()
    
    private var models = [UserNotification]()
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchNotification()
        navigationItem.title = "Notification"
        view.addSubview(spinner)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0,
                               y: 0,
                               width: 100,
                               height: 100)
        spinner.center = view.center
        
    }
    
    private func addNoNotificationView() {
        tableView.isHidden = true
        view.addSubview(tableView)
        noNotificationsView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: view.width/2,
                                           height: view.height/4)
        
        noNotificationsView.center = view.center
    }
    
    private func fetchNotification() {
        for x in 0...100 {
            
            let user = User(username: "Bruce Wyne", profilePhoto: URL(string: "https://www.google.com")!, bio: "", name: (first: "",last: ""), birthDate: Date(), gender: .male, counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
            
            let post = UserPost(postType: .photo, thumbNailImage: URL(string: "https://www.google.com")!, postURL: URL(string: "https://www.google.com")!, caption: nil, likeCount: [], comments: [], createdDate: Date(), taggedUsers: [], owner: user)
            
            let model = UserNotification(type: x % 2 == 0 ? .like(post: post) : .follow(state: .following), text: "Hello world", user: user)
            
            models.append(model)
        }
        
    }

}

//MARK: - UITableViewDelegate

extension NotificationViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let model = models[indexPath.row]
        switch model.type {
            
        case .like(_):
            
            //like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NoNotificationsLikeEventTableViewCell.identifier, for: indexPath) as! NoNotificationsLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        case .follow:
            
            //follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NoNotificationsFollowEventTableViewCell.identifier, for: indexPath) as! NoNotificationsFollowEventTableViewCell
            cell.delegate = self
//            cell.configure(with: model)
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

//MARK: - NoNotificationsLikeEventTableViewCellDelegate

extension NotificationViewController: NoNotificationsLikeEventTableViewCellDelegate {
    func didTapRelatedPostButton(model: UserNotification) {
        
        switch model.type {
            
        case .like(post: let post):
            let vc = PostViewController(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow(_):
            fatalError("Dev Isssue: Should never get called.")
        }
        
    }
    
    
}

//MARK: - NoNotificationsFollowEventTableViewCellDelegate

extension NotificationViewController: NoNotificationsFollowEventTableViewCellDelegate {
    func didTapFollowUnFollowButton(model: UserNotification) {
        print("Tap Follow Button")
        //perform database update
    }
    
    
}


//
//  PostViewController.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/11/24.
//

import UIKit

struct PostRenderViewModel {
    let renderType: PostRenderType
}

enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: UserPost)
    case actions(provider: String)
    case comments(provider : [PostComment])
}

class PostViewController: UIViewController {
    
    private let model : UserPost?
    
    private var renderModel = [PostRenderViewModel]()
    
    private let tableView: UITableView = {
        
        let tableview = UITableView()
    
        tableview.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableview.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableview.register(IGFeedPostActionTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionTableViewCell.identifier)
        tableview.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        tableview.separatorStyle = .singleLine
        return tableview
    }()
    
    init(model: UserPost?){
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModel()
    }
    
    private func configureModel() {
        guard let userPostMoel = self.model else {
            return
        }
        renderModel.removeAll()
        //Header
        
        renderModel.append(PostRenderViewModel(renderType: .header(provider: userPostMoel.owner)))
        //Post
        renderModel.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostMoel)))
        
        //Action
        renderModel.append(PostRenderViewModel(renderType: .actions(provider: "")))
        
        renderModel.append(PostRenderViewModel(renderType: .comments(provider: userPostMoel.comments)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - UITableView Delegate

extension PostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITableView DataSource

extension PostViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModel.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModel[section].renderType{
            
        case .header(_):
            return 1
        case .primaryContent(_):
            return 1
        case .actions(_):
            return 1
        case .comments(let comment):
           return comment.count > 2 ? 2: comment.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = renderModel[indexPath.section]
        
        switch model.renderType {
            
        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
            cell.configure(with: user)
            return cell
        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
            cell.configure(with: post)
            return cell
        case .actions(let action):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionTableViewCell.identifier, for: indexPath) as! IGFeedPostActionTableViewCell
            cell.configure(model: action)
            return cell
        case .comments(let provider):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
            cell.configure(model: provider[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = renderModel[indexPath.section]
        
        switch model.renderType {
        
        case .header(_):
            return 70
        case .primaryContent(_):
            return tableView.width
        case .actions(_):
            return 60
        case .comments(_):
            return 50
        }
    }
}

//
//  SettingsViewController.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/11/24.
//

import UIKit
import SafariServices

struct SettingCellModel {
    
    let title : String
    let handler: (() -> Void)
}

enum SettingURLType {
    case terms, privacy, help
}

class SettingsViewController: UIViewController {
    
    private let tableView : UITableView = {
        
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    private var data = [[SettingCellModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }

    private func configureModels() {
        
        data = [
            [
                SettingCellModel(title: "Edit Profile"){ [weak self] in
                    self?.didTapEditProfile()
                },
                SettingCellModel(title: "Invite Friends"){ [weak self] in
                    self?.didTapInviteFriends()
                },
                SettingCellModel(title: "Save Origin Posts"){ [weak self] in
                    self?.didTapSaveOriginPosts()
                }
            ],
            [
                SettingCellModel(title: "Terms of Service"){ [weak self] in
                    self?.openURL(type: .terms)
                },
                SettingCellModel(title: "Privacy Policy"){ [weak self] in
                    self?.openURL(type: .privacy)
                },
                SettingCellModel(title: "Help / Feedback"){ [weak self] in
                    self?.openURL(type: .help)
                }
            ],
            [
                SettingCellModel(title: "Log Out"){ [weak self] in
                    self?.didTapLogOut()
                }
            ],
        ]
        
    }
    
    private func didTapLogOut() {
        
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to logout", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.LogOut { success in
                
                DispatchQueue.main.async {
                    
                    switch success {
                        
                    case true:
                        
                        let logInVC = LoginViewController()
                        logInVC.modalPresentationStyle = .fullScreen
                        self.present(logInVC, animated: true){
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                        
                    case false:
                        //error occured
                        fatalError("Could not logout user")
                    }
                }
            }
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        
        present(actionSheet, animated: true)
    }
    
    private func didTapInviteFriends() {
        //show sheet to invite friends
    }
    
    private func didTapSaveOriginPosts() {
       //
    }
        
    private func openURL(type: SettingURLType){
        let urlString : String
        switch type {
        case .help: urlString = "https://help.instagram.com/155833707900388"
        case .privacy: urlString = "https://help.instagram.com/search/?helpref=search&query=privacy%20policy"
        case .terms: urlString = "https://help.instagram.com/581066165581870/?helpref=hc_fnav&locale=en_AU"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let naVC = UINavigationController(rootViewController: vc)
        naVC.modalPresentationStyle = .fullScreen
        present(naVC, animated: true)
    }
    
}

//MARK: - TableView Delegate

extension SettingsViewController: UITableViewDelegate {
    
}

//MARK: - TableView DataSource

extension SettingsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        data[indexPath.section][indexPath.row].handler()
    }
}


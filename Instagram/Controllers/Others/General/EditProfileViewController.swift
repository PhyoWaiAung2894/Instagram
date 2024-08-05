//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/11/24.
//

import UIKit

struct EditProfileFormModel {
    
    let label : String
    let placeholder : String
    var value : String?
}

final class EditProfileViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
        return tableview
    }()

    private var model = [[EditProfileFormModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureModel()

        tableView.tableHeaderView = createTableHeaderView()
        tableView.dataSource = self
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(didTapCancleButton))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModel() {
        
        //name, username, website, bio
        let section1Labels = ["Name", "Username", "Bio"]
        var section1 = [EditProfileFormModel]()
        
        for label in section1Labels {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)", value: nil)
            section1.append(model)
        }
        
        model.append(section1)
        
        //email, phone, gender
        
        let section2Labels = ["Email", "Phone", "Gender"]
        var section2 = [EditProfileFormModel]()
        
        for label in section2Labels {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)", value: nil)
            section2.append(model)
        }
        model.append(section2)
        
    }
    private func createTableHeaderView() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/4).integral)
        let size = header.height/1.5
        let profiePhotoButton = UIButton(frame: CGRect(x: (view.width-size)/2, y: (header.height-size)/2, width: size, height: size))
        
        profiePhotoButton.layer.masksToBounds = true
        profiePhotoButton.layer.cornerRadius = size/2.0
        profiePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)
        profiePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        profiePhotoButton.tintColor = .label
        profiePhotoButton.layer.borderWidth = 1
        profiePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        header.addSubview(profiePhotoButton)
        return header
    }
    
    
    @objc private func didTapSaveButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCancleButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapProfilePhotoButton() {
        
    }
    
    @objc private func didTapChangeProfilePicture() {
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Change Profile Picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Chose from gallery", style: .default, handler: { _ in
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        
        present(actionSheet, animated: true)
    }

}

//MARK: -UITableView DataSource

extension EditProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = model[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
        cell.delegate = self
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "Private Information"
    }
}

//MARK: - FormTableViewCell Delegate

extension EditProfileViewController: FormTableViewCellDelegate {
    
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updateModel: EditProfileFormModel) {
        print("Faild to update to model\(String(describing: updateModel))")
    }
}

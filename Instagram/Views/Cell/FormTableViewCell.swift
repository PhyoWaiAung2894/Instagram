//
//  FormTableViewCell.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/19/24.
//

import UIKit

protocol FormTableViewCellDelegate : AnyObject {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updateModel: EditProfileFormModel)
}

class FormTableViewCell: UITableViewCell {
    
    static let identifier = "FormTableViewCell"
    
    private var model : EditProfileFormModel?
    
    public weak var delegate: FormTableViewCellDelegate?
    
    private let formLabel : UILabel = {
        
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let field : UITextField = {
        
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(field)
        selectionStyle = .none
        field.delegate = self
    }
    
    public func configure(with model: EditProfileFormModel){
        self.model = model
        formLabel.text = model.label
        field.placeholder = model.placeholder
        field.text = model.value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        formLabel.text = nil
        field.placeholder = nil
        field.delegate = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Assign frames
        formLabel.frame = CGRect(x: 5, y: 0, width: contentView.width/3, height: contentView.height)
        field.frame = CGRect(x: formLabel.right, y: 0, width: contentView.width-10-formLabel.width, height: contentView.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -UITextField Delegate

extension FormTableViewCell : UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        model?.value = textField.text
        guard let model = model else {
             return true
        }
        
        delegate?.formTableViewCell(self, didUpdateField: model)
        textField.resignFirstResponder()
        return true
    }
}

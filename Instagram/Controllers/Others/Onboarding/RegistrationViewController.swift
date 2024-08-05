//
//  RegistrationViewController.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/11/24.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    //OutLet
    
    private let usernameField : UITextField = {
        
        let field = UITextField()
        field.placeholder = "Username..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 10
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let emailField : UITextField = {
        
        let field = UITextField()
        field.placeholder = "Email..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 10
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let passwordField : UITextField = {
        
        let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "Password..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 10
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let registerButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGreen
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)

        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        usernameField.frame = CGRect(x: 20
                                     , y: view.safeAreaInsets.top + 10,
                                     width: view.width - 40,
                                     height: 52
        )
        
        emailField.frame = CGRect(x: 20
                                  , y: usernameField.bottom + 10,
                                     width: view.width - 40,
                                     height: 52
        )
        
        passwordField.frame = CGRect(x: 20
                                     , y: emailField.bottom + 10,
                                     width: view.width - 40,
                                     height: 52
        )
        
        registerButton.frame = CGRect(x: 20
                                      , y: passwordField.bottom + 10,
                                     width: view.width - 40,
                                     height: 52
        )
    }
    
    @objc func didTapRegisterButton() {
        
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, !email.isEmpty, let username = usernameField.text, !username.isEmpty, let password = passwordField.text, !password.isEmpty, password.count >= 8 else {
            return
        }
        
        AuthManager.shared.registerNewUser(username: username, email: email, password: password) { registered in
            
            DispatchQueue.main.async {
                
                if registered {
                    
                }else {
                    
                }
            }
        }
        
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

extension RegistrationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else {
            didTapRegisterButton()
        }
        
        return true
    }
}

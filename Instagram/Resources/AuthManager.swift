//
//  AuthManager.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/12/24.
//
import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    //MARK: - Public
    
    public func registerNewUser(username: String, email: String, password: String,completion: @escaping (Bool)-> Void) {
        
        /*
         -Check if username is available
         -Check if email is available
         */
        
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            
            if canCreate {
                /*
                 -Create Account
                 -Insert Account to database
                 */
                Auth.auth().createUser(withEmail: email, password: password) { AuthDataResult, error in
                    
                    guard error == nil, AuthDataResult != nil  else{
                        completion(false)
                        return
                    }
                    
                    //Insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        
                        if inserted {
                            completion(true)
                        }else{
                            completion(false)
                            return
                        }
                    }
                }
            }else {
                //either username or email does not exit
                completion(true)
            }
        }
    }

    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        
        if let email = email {
            
            //Email Login
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                
                guard authResult != nil, error == nil else {
                    
                    completion(false)
                    return
                }
                
                completion(true)
            }
            
        }else if let username = username {
            
            //Username Login
            print(username)
        }
    }

    public func LogOut(completion: @escaping ((Bool) -> Void)){
        
        do{
            try Auth.auth().signOut()
            completion(true)
            return
        }catch{
            completion(false)
            print(error)
            return
        }
    }
}

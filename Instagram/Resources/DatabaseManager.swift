//
//  DatabaseManager.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/12/24.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    //MARK: - Public
    
    //Check if user name and email is available
    //-Parameters
    //  -email: String representing email
    //   -username: String representing email
    public func canCreateNewUser(with email: String, username: String,completion: @escaping (Bool) -> Void){
        completion(true)
    }
    
    //Insert new user to database
    //-Parameters
    //  -email: String representing email
    //   -username: String representing email
    
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool)-> Void){
        database.child(email.safeDatabaseKey()).setValue(["username": username]) { error, _ in
            
            if error == nil {
                //succeeded
                completion(true)
            }else {
                //failed
                completion(false)
            }
        }
    }
}

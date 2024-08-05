//
//  StorageManager.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/12/24.
//

import FirebaseStorage

public class StorageManager {
    
    static let shared = StorageManager()
    
    public enum IGStorageManagerError:Error {
        case failedToDownload
    }
    
    private let bucket = Storage.storage().reference()
    //MARK: - Public

    public func uploadUserPhotoPost(model: UserPost,completion: (Result<URL,Error>)-> Void){
        
    }
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, IGStorageManagerError>)-> Void){
        bucket.child(reference).downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(.failedToDownload))
                return
            }
            
            completion(.success(url))
        }
    }
}



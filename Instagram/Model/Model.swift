//
//  Model.swift
//  Instagram
//
//  Created by PhyoWai Aung on 7/22/24.
//

import Foundation

public enum UserPostType: String {
    case photo = "Photo", video = "Video"
}

enum Gender {
    case male, female, other
}

///Represent a user post
public struct UserPost {
    let postType: UserPostType
    let thumbNailImage : URL
    let postURL : URL // either video url or full resolution photo
    let caption : String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let createdDate : Date
    let taggedUsers: [String]
    let owner: User
}

public struct PostComment {
    
    let identifier: String
    let username: String
    let text: String
    let createdDate: String
    let likeCount: [CommentLike]
}

public struct PostLike {
    
    let username : String
    
}

public struct CommentLike {
    
    let username: String
    let commentIdentifier: String
    
}

struct User {
    let username : String
    let profilePhoto : URL
    let bio: String
    let name: (first: String, last: String)
    let birthDate: Date
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

//
//  APImodels.swift
//  Unsplash-Images
//
//  Created by Karthikeyan Muthu on 30/10/23.
//

import Foundation

struct APIResponse: Codable{
    let results:[Result]
}
struct Result:Codable{
    let id: String?
    let slug: String?
    let created_at: String?
    let description: String?
    let alt_description: String?
    let urls: URLS?
    let user: User?
}
struct URLS:Codable{
    let full: String?
    let small: String?
}
struct User:Codable{
    let first_name: String?
    let last_name: String?
    let twitter_username: String?
    let bio: String?
    let location: String?
}

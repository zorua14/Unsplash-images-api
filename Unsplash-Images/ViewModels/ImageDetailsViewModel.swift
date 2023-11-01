//
//  ImageDetailsViewModel.swift
//  Unsplash-Images
//
//  Created by Karthikeyan Muthu on 31/10/23.
//

import Foundation
import UIKit
class ImageDetailsViewModel{
    static let shared = ImageDetailsViewModel()
    func setDetails(_ data:Result,_ vc: ImageDetailsViewController){
        
        var username:String = "Username"
        
        // ok na
        if data.user?.twitter_username != nil{
            vc.twitterUserName.text = data.user?.twitter_username!
        }else{
            vc.twitterUserName.text = "Username"
        }
        if data.user?.bio != nil{
            vc.bio.text = data.user?.bio!
        }else{
            vc.bio.text = "Bio was not provided"
        }
        if data.user?.location != nil{
            vc.location.text = data.user?.location!
        }else{
            vc.location.text = "Location"
        }
        if data.description != nil{
            vc.desc.text = data.description!
        }else{
            vc.desc.text = "No description available"
        }
        if data.user?.first_name != nil{
            username =  (data.user?.first_name)!
            if data.user?.last_name != nil{
                username = "\(username) \((data.user?.last_name)!)"
            }
        }
        vc.userName.text = username
        vc.navigationItem.hidesBackButton = true
        self.configure(with: (data.urls?.full)!, vc)
        
    }
    func configure(with urlString: String,_ vc:ImageDetailsViewController ){
        guard let url = URL(string: urlString) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                vc.displayImage.image = image
                vc.spinner.stopAnimating()
            }
        }
        task.resume()
    }
}
